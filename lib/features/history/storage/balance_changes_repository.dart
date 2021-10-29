import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_order.dart' as pagination;
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/fee.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/data/storage%20/model/paging_order.dart';
import 'package:flutter_template/data/storage%20/model/participant_effects_page_params.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/paged_data_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/model/balance_change_action.dart';

class BalanceChangesRepository extends PagedDataRepository<BalanceChange> {
  String? _balanceId;
  String? _accountId;
  ApiProvider _apiProvider;
  PagedDataCache<BalanceChange> dataCache;

  BalanceChangesRepository(
      this._balanceId, this._accountId, this._apiProvider, this.dataCache)
      : super(PagingOrder.desc, dataCache);

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

  @override
  Future<DataPage<BalanceChange>> getRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    print('nextCursor is $nextCursor');
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

    var next = nextCursor ?? null;
    String? nextC;
    if (next != null) nextC = next.toString();
    params.withPagingParams(PagingParamsV2(nextC, pageLimit,
        pagination.PagingOrder.ASC)); //TODO sync with PagingOrder from SDK

    if (_balanceId != null) {
      params.withBalance(_balanceId!);
    } else {
      params.withAccount(_accountId!);
    }

    try {
      var dataPage = signedApi
          .getService()
          .get('v3/history', query: params.build().map())
          .then((response) {
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

        var items = participantEffects.map((effect) {
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
        var nextLink = Uri.decodeFull(response['links']['next']);

        var limit = int.parse(
            DataPage.getNumberParamFromLink(nextLink, 'page\\[limit\\]') ??
                "0");

        var isLast = response['links']['next'] == null || items.length < limit;
        log('RESPONSE: $response');

        var nextCursor = DataPage.getNumberParamFromLink(
                Uri.decodeFull(response['links']['next']),
                'page\\[cursor\\]') ??
            DataPage.getNumberParamFromLink(
                Uri.decodeFull(response['links']['next']), 'page\\[number\\]');
        return DataPage((nextCursor), items, isLast);
      });
      return dataPage;
    } catch (e, s) {
      print(e);
      print(s.toString());
      return Future.error(e);
    }
  }
}
