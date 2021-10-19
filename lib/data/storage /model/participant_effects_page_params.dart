import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pageQuery;

class ParticipantEffectsPageParams extends pageQuery.PageQueryParams {
  ParticipantEffectsPageParams(
      this.account, this.balance, this.asset, this.include, this.pagingParams)
      : super(pagingParams, include);

  String? account;
  String? balance;
  String? asset;
  List<String>? include;
  PagingParamsV2? pagingParams;

  @override
  Map<String, dynamic> map() {
    var map = super.map();

    if (account != null) map.putFilter('account', account);
    if (balance != null) map.putFilter('balance', balance);
    if (asset != null) map.putFilter('asset', asset);

    return map;
  }
}

class ParticipantEffectsPageParamsBuilder extends pageQuery.Builder {
  String? account;
  String? balance;
  String? asset;

  withAccount(String account) {
    this.account = account;
  }

  withBalance(String balance) {
    this.balance = balance;
  }

  withAsset(String asset) {
    this.asset = asset;
  }

  withPagingParams(PagingParamsV2 pagingParams) {
    this.pagingParams = pagingParams;
  }

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  ParticipantEffectsPageParams build() {
    return ParticipantEffectsPageParams(account, balance, asset, include, pagingParams);
  }
}

class ParticipantEffectsParams extends jsonApiQueryParams.JsonApiQueryParams {
  List<String>? include;

  ParticipantEffectsParams(this.include) : super(include);

  static const OPERATION = 'operation';
  static const OPERATION_DETAILS = 'operation.details';
  static const EFFECT = 'effect';
}
