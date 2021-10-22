import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/fee.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/data/storage%20/model/participant_effects_page_params.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/model/balance_change_action.dart';

class BalanceChangesRepository extends MultipleItemsRepository<BalanceChange> {
  //TODO make repository load data by pages
  String? _balanceId;
  String? _accountId;
  ApiProvider _apiProvider;
  PagedDataCache<BalanceChange> dataCache;

  BalanceChangesRepository(
      this._balanceId, this._accountId, this._apiProvider, this.dataCache);

  @override
  Future<List<BalanceChange>> getItems() async {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null) {
      return Future.error(StateError('No signed API instance found'));
    }

    var params = ParticipantEffectsPageParamsBuilder();
    params.withInclude(List.of([
      ParticipantEffectsParams.OPERATION,
      ParticipantEffectsParams.OPERATION_DETAILS,
      ParticipantEffectsParams.EFFECT,
    ]));

    if (_balanceId != null) {
      params.withBalance(_balanceId!);
    } else {
      params.withAccount(_accountId!);
    }

    try {
      var itemsList = signedApi
          .getService()
          .get('v3/history', query: params.build().map())
          .then((response) {
        log('RESPONSE ${response['data']}');
        var data = json.decode(json.encode(response['data'])) as List<dynamic>;
        var included =
            json.decode(json.encode(response['included'])) as List<dynamic>;

        var participantEffects =
            data.where((dataItem) => dataItem['type'] == 'participant-effects');
        var effectsCharged = included.where((include) =>
            include['type'] == 'effects-charged' ||
            include['type'] == 'effects-issued');
        var operationsPayment = included
            .where((include) => include['type'] == 'operations-payment');
        var operations =
            included.where((include) => include['type'] == 'operations');

        return participantEffects.map((effect) {
          var relatedEffect = effectsCharged.firstWhere((element) =>
              element['id'] == effect['relationships']['effect']['data']['id']);

          var relatedOp = operations.firstWhere((element) =>
              element['id'] ==
              effect['relationships']['operation']['data']['id']);

          var action = getBalanceChangeAction(
              effect['relationships']['effect']['data']['type']);

          return BalanceChange(
              int.parse(relatedEffect['id']),
              action,
              Decimal.parse(relatedEffect['attributes']['amount']),
              SimpleAsset(
                  effect['relationships']['asset']['data']['id'], '', 6),
              effect['relationships']['balance']['data']['id'],
              SimpleFeeRecord.fromFee(
                  Fee.fromJson(relatedEffect['attributes']['fee'])),
              DateTime.parse(relatedOp['attributes']['applied_at']));
        }).toList();
      });
      streamController.sink.add(await itemsList);

      return itemsList;
    } catch (e, s) {
      print(s.toString());
      return Future.error(e);
    }

  }

  BalanceChangeAction getBalanceChangeAction(String effect) {
    switch (effect) {
      case 'effects-locked':
        return BalanceChangeAction.locked;
      case 'effects-charged-from-locked':
        return BalanceChangeAction.charged_from_locked;
      case 'effects-unlocked':
        return BalanceChangeAction.unlocked;
      case 'effects-charged':
        return BalanceChangeAction.charged;
      case 'effects-withdrawn':
        return BalanceChangeAction.withdrawn;
      case 'effects-matched':
        return BalanceChangeAction.matched;
      case 'effects-issued':
        return BalanceChangeAction.issued;
      case 'effects-funded':
        return BalanceChangeAction.funded;
      default:
        return BalanceChangeAction.locked;
    }
  }

  getFromPageData(Map<String, dynamic> response) {
    var included =
        json.decode(json.encode(response['included'])) as List<dynamic>;
    var effectsCharged =
        included.where((include) => include['type'] == 'effects-charged');
    var operationsPayment =
        included.where((include) => include['type'] == 'operations-payment');
    var operations =
        included.where((include) => include['type'] == 'operations');

    var selfLink = Uri.decodeFull(response['links']['self'] /*?['href']*/);
    if (selfLink == null) {
      ArgumentError('Self link can\'t be null');
    }

    var nextLink = Uri.decodeFull(response['links']['self'] /*?['href']*/);

    var selfCursor = DataPage.getNumberParamFromLink(
        selfLink, PagingParamsV2.QUERY_PARAM_PAGE_CURSOR);
    var selfPageNumber = DataPage.getNumberParamFromLink(
        selfLink, PagingParamsV2.QUERY_PARAM_PAGE_NUMBER);

    var nextCursor = selfCursor;
    if (nextCursor != null)
      DataPage.getNumberParamFromLink(
          nextLink, PagingParamsV2.QUERY_PARAM_PAGE_CURSOR);

    var nextPageNumber = selfPageNumber;
    nextPageNumber = DataPage.getNumberParamFromLink(
        nextLink, PagingParamsV2.QUERY_PARAM_PAGE_NUMBER);

    var next = nextPageNumber;
    if (selfCursor != nextCursor) {
      next = nextCursor;
    }

    var limit = int.parse(DataPage.getNumberParamFromLink(
            nextLink, PagingParamsV2.QUERY_PARAM_LIMIT) ??
        "0");

    var isLast = nextLink == null;
    return DataPage(next, List.empty(), isLast);
  }
}
