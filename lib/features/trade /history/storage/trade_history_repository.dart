import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/params/matches_page_params.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/paged_data_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/trade%20/history/model/trade_history_record.dart';

class TradeHistoryRepository extends PagedDataRepository<TradeHistoryRecord> {
  String _baseAsset;
  String _quoteAsset;
  ApiProvider _apiProvider;

  TradeHistoryRepository(
    this._baseAsset,
    this._quoteAsset,
    this._apiProvider,
  ) : super(PagingOrder.DESC, MemoryOnlyPagedDataCache<TradeHistoryRecord>());

  @override
  Future<DataPage<TradeHistoryRecord>> getRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    var signedApi = _apiProvider.getSignedApi();

    var requestParams = MatchesPageParams(
      baseAsset: _baseAsset,
      quoteAsset: _quoteAsset,
      pagingParams: PagingParamsV2(nextCursor.toString(), 15, requiredOrder),
    );

    return signedApi
        .getService()
        .get(
          'v3/matches',
          query: requestParams.map(),
        )
        .then((response) {
      var data = json.decode(json.encode(response['data'])) as List<dynamic>;
      var offers =
          data.map((item) => TradeHistoryRecord.fromJson(item)).toList();
      var nextLink = Uri.decodeFull(response['links']['next']);

      var limit = int.parse(
          DataPage.getNumberParamFromLink(nextLink, 'page\\[limit\\]') ?? "0");

      var isLast = response['links']['next'] == null || offers.length < limit;
      log('RESPONSE: $response');

      var nextCursor = DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']), 'page\\[cursor\\]') ??
          DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']),
              'page\\[number\\]'); //TODO rewrite with SDK static methods
      return DataPage((nextCursor), offers, isLast);
    });
  }
}
