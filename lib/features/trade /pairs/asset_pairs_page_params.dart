import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pageQuery;
import 'package:dart_wallet/xdr/xdr_types.dart';

class AssetPairsPageParams extends pageQuery.PageQueryParams {
  Iterable<AssetPairPolicy>? policies;
  String? baseAsset;
  String? quoteAsset;

  AssetPairsPageParams(
      {this.policies,
      this.baseAsset,
      this.quoteAsset,
      PagingParamsV2? pagingParams,
      List<String>? include})
      : super(pagingParams, include);

  @override
  Map<String, dynamic> map() {
    var map = super.map();

    if (policies != null)
      map.putFilter('policy', policies!.map((e) => e.value));
    if (baseAsset != null) map.putFilter('base_asset', baseAsset!);
    if (quoteAsset != null) map.putFilter('quote_asset', quoteAsset!);

    return map;
  }
}

class AssetPairsPageParamsBuilder extends pageQuery.Builder {
  Iterable<AssetPairPolicy>? policies;
  String? baseAsset;
  String? quoteAsset;

  withPolicies(Iterable<AssetPairPolicy> policies) => this.policies = policies;

  withBaseAsset(String asset) => this.baseAsset = asset;

  withQuoteAsset(String asset) => this.quoteAsset = asset;

  withPagingParams(PagingParamsV2 pagingParams) =>
      this.pagingParams = pagingParams;

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  pageQuery.PageQueryParams build() {
    return AssetPairsPageParams(
        policies: policies,
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        pagingParams: pagingParams,
        include: include);
  }
}

class AssetPairsParams extends jsonApiQueryParams.JsonApiQueryParams {
  List<String>? include;

  AssetPairsParams(this.include) : super(include);

  static const BASE_ASSET = 'base_asset';
  static const QUOTE_ASSET = 'quote_asset';
}
