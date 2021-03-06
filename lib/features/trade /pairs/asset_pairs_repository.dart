import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/storage/simple_paged_resource_loader.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/trade%20/pairs/amount_converter.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_page_params.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AssetPairsRepository extends MultipleItemsRepository<AssetPairRecord>
    implements AmountConverter {
  ApiProvider _apiProvider;
  UrlConfigProvider _urlConfigProvider;

  AssetPairsRepository(this._apiProvider, this._urlConfigProvider);

  static var PAGE_LIMIT = 20;

  @override
  Future<List<AssetPairRecord>> getItems() async {
    UrlConfig urlConfig = _urlConfigProvider.getConfig();

    var loader = SimplePagedResourceLoader<AssetPairRecord>((nextCursor) {
      return _apiProvider
          .getApi()
          .getService()
          .get('v3/asset_pairs',
              query: AssetPairsPageParams(
                      include: List.of([
                        AssetPairsParams.BASE_ASSET,
                        AssetPairsParams.QUOTE_ASSET
                      ]),
                      pagingParams:
                          PagingParamsV2(nextCursor, PAGE_LIMIT, null))
                  .map())
          .then((response) {
        var itemsList = (response['data'] as List<dynamic>)
            .map((e) => AssetPairRecord.fromJson(e, urlConfig))
            .toList();

        var nextLink = DataPage.getNextLink(response);
        var limit = DataPage.getLimit(response, nextLink);

        var isLast = DataPage.isLastOne(
          response,
          limit,
          itemsList.length,
        );
        var nextCursor = DataPage.getNextPageCursor(response);
        return DataPage(nextCursor, itemsList, isLast);
      });
    });
    var itemsList = await loader.loadAll();
    streamSubject.sink.add(itemsList);

    return itemsList;
  }

  @override
  Decimal? convert(Decimal amount, String sourceAsset, String destAsset) {
    var rate = getRate(sourceAsset, destAsset);
    if (rate != null) {
      return amount * rate;
    }
  }

  @override
  Decimal convertOrSame(Decimal amount, String sourceAsset, String destAsset) {
    return convert(amount, sourceAsset, destAsset) ?? amount;
  }

  @override
  Decimal? getRate(String sourceAsset, String destAsset) {
    if (sourceAsset == destAsset) return Decimal.one;

    var pairs = streamSubject.value;
    Decimal? mainPairPrice = pairs
        .firstWhereOrNull(
          (element) =>
              element.quote.code == destAsset &&
              element.base.code == sourceAsset,
        )
        ?.price;
    var quotePair = pairs.firstWhereOrNull((element) =>
        element.quote.code == destAsset &&
        element.base.code ==
            sourceAsset);
    Decimal? quotePairPrice;
    if (quotePair?.price != null) {
      quotePairPrice = Decimal.one / quotePair!.price;
    }

    return mainPairPrice ?? quotePairPrice;
  }

  @override
  Decimal getRateOrOne(String sourceAsset, String destAsset) {
    return getRate(sourceAsset, destAsset) ?? Decimal.one;
  }
}
