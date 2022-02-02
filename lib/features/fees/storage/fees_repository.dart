import 'dart:convert';

import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/model/account_params.dart';
import 'package:flutter_template/features/fees/model/fee_record.dart';

class FeesRepository extends MultipleItemsRepository<FeeRecord> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;
  UrlConfig _urlConfig;

  FeesRepository(this._apiProvider, this._walletInfoProvider, this._urlConfig);

  @override
  Future<List<FeeRecord>> getItems() {
    var signedApi = _apiProvider.getSignedApi();
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      throw Future.error(StateError('No wallet info found'));

    return signedApi
        .getService()
        .get('v3/accounts/$accountId',
            query: AccountParams([AccountParams.FEES]).map())
        .then((response) {
      var included =
          json.decode(json.encode(response['included'])) as List<dynamic>;

      var fees = included.where((include) => include['type'] == 'fees');

      return fees.map((fee) => FeeRecord.fromJson(fee, _urlConfig)).toList();
    });
  }
}
