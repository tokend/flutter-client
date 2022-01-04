import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/attributes_entity.dart';
import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';

class TfaFactorsRepository extends MultipleItemsRepository<TfaFactor> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;

  TfaFactorsRepository(this._apiProvider, this._walletInfoProvider);

  @override
  Future<List<TfaFactor>> getItems() async {
    var signedApi = _apiProvider.getSignedApi();
    var walletId = _walletInfoProvider.getWalletInfo()?.walletIdHex;
    if (walletId == null)
      return Future.error(StateError('No wallet info found'));

    try {
      var items = signedApi
          .getService()
          .get('wallets/$walletId/factors')
          .then((response) {
        var data = json.decode(json.encode(response['data'])) as List<dynamic>;
        return data.map((e) => TfaFactor.fromJson(e)).toList();
      });
      streamSubject.add(await items);
      return items;
    } catch (e, s) {
      log('ERROR OCCURRED');
      log('$e ${s.toString()}');
      return [];
    }
  }

  /// Adds given factor as disabled,
  /// locally adds it to repository on complete
  Future<Map<String, dynamic>> addFactor(TfaFactorType type) {
    var signedApi = _apiProvider.getSignedApi();
    var walletId = _walletInfoProvider.getWalletInfo()?.walletIdHex;
    if (walletId == null)
      return Future.error(StateError('No wallet info found'));

    return signedApi.getService().post('wallets/$walletId/factors',
        body: DataEntity(FactorBody(type.name.toLowerCase())).toJson());
  }

  /// Adds given factor as disabled,
  /// locally adds it to repository on complete
  Future<Map<String, dynamic>> setFactorAsMain(int id) {
    var signedApi = _apiProvider.getSignedApi();
    var walletId = _walletInfoProvider.getWalletInfo()?.walletIdHex;
    int newPriority = 0;

    if (walletId == null)
      return Future.error(StateError('No wallet info found'));

    log('setFactorAsMain');
    return signedApi.getService().patch('wallets/$walletId/factors/$id',
        body: AttributesEntity(Map.from({'priority': newPriority})));
  }

  /// Deletes factor with given id,
  /// locally deletes it from repository on complete
  Future<Map<String, dynamic>> deleteFactor(int id) {
    var signedApi = _apiProvider.getSignedApi();
    var walletId = _walletInfoProvider.getWalletInfo()?.walletIdHex;
    if (walletId == null)
      return Future.error(StateError('No wallet info found'));

    return signedApi.getService().delete(
          'wallets/$walletId/factors/$id',
        );
  }
}

class FactorBody {
  String type;

  FactorBody(this.type);

  Map<String, dynamic> toJson() => {'type': type};
}
