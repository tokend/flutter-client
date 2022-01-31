import 'dart:convert';

import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:get/get.dart';

class AssetsRepository extends MultipleItemsRepository<AssetRecord> {
  ApiProvider _apiProvider;
  late WalletInfoProvider _walletInfoProvider;
  late UrlConfigProvider _urlConfigProvider;

  AssetsRepository(
      this._apiProvider, this._walletInfoProvider, this._urlConfigProvider);

  @override
  Future<List<AssetRecord>> getItems() async {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null)
      return Future.error(StateError('No signed API instance found'));
    _walletInfoProvider = Get.find();
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));

    var assetRecords = signedApi
        .getService()
        .get(
          'v3/assets',
        )
        .then((response) {
      var data = json.decode(json.encode(response['data'])) as List<dynamic>;

      return data
          .map((asset) =>
              AssetRecord.fromJson(asset, _urlConfigProvider.getConfig()))
          .toList();
    });

    streamSubject.sink.add(await assetRecords);
    return assetRecords;
  }

  /// Returns single asset info by id
  Future<AssetRecord> getById(String code) async {
    var cachedValue = null;

    if (cachedValue == null) {
      var newValue = await _apiProvider
          .getApi()
          .getService()
          .get('assets/$code')
          .then((response) => AssetRecord.single(
              response, this._urlConfigProvider.getConfig()));
      singleSubject.add(newValue);
      return newValue;
    } else {
      singleSubject.add(cachedValue);
      return Future.value(cachedValue);
    }
  }
}
