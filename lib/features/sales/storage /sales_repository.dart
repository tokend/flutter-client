import 'dart:convert';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/params/sales_page_params_v3.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/paged_data_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/sales/model/sale_record.dart';

class SalesRepository extends PagedDataRepository<SaleRecord> {
  WalletInfoProvider _walletInfoProvider;
  ApiProvider _apiProvider;

  SalesRepository(
    this._walletInfoProvider,
    this._apiProvider,
  ) : super(PagingOrder.DESC, MemoryOnlyPagedDataCache<SaleRecord>());

  @override
  Future<DataPage<SaleRecord>> getRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    String? baseAsset;

    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));

    var signedApi = _apiProvider.getSignedApi();

    var requestParams = SalesPageParamsV3(
        pagingParamsV2:
            PagingParamsV2(nextCursor.toString(), 15, requiredOrder),
        saleState: 1,
        baseAsset: baseAsset,
        include: List.of([
          SalesParams.BASE_ASSET,
          SalesParams.QUOTE_ASSET,
          SalesParams.DEFAULT_QUOTE_ASSET,
        ]));

    return signedApi
        .getService()
        .get('v3/accounts/$accountId/sales', query: requestParams.map())
        .then((response) {
      var data = json.decode(json.encode(response['data'])) as List<dynamic>;
      var included =
          json.decode(json.encode(response['included'])) as List<dynamic>;
      var sales = data
          .map((item) => SaleRecord.fromJson(
              item,
              included.firstWhere((element) =>
                  element['type'] == 'sale-quote-assets' &&
                  element['id'] ==
                      item['relationships']['default_quote_asset']['data']
                          ['id'])))
          .toList();
      var nextLink = Uri.decodeFull(response['links']['next']);

      var limit = int.parse(
          DataPage.getNumberParamFromLink(nextLink, 'page\\[limit\\]') ?? "0");

      var isLast = response['links']['next'] == null || sales.length < limit;

      var nextCursor = DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']), 'page\\[cursor\\]') ??
          DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']),
              'page\\[number\\]'); //TODO rewrite with SDK static methods
      return DataPage((nextCursor), sales, isLast);
    });
  }
}
