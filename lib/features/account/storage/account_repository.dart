import 'dart:convert';

import 'package:dart_sdk/api/transactions/transactions_api.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/model/account_params.dart';
import 'package:flutter_template/features/account/model/account_record.dart';

class AccountRepository extends SingleItemRepository<AccountRecord> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;
  ObjectPersistence<AccountRecord>? itemPersistence;

  AccountRepository(
      this._apiProvider, this._walletInfoProvider, this.itemPersistence);

  @override
  Future<AccountRecord> getItem() async {
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null)
      return Future.error(StateError('No signed API instance found'));

    var response = await signedApi.getService().get('v3/accounts/$accountId',
        query: AccountParams(List.of([AccountParams.KYC_DATA])).map());

    printLongString('Response from Account Repository ${json.encode(response)}');
    return AccountRecord.fromJson(response);
  }

  updateKycRecoveryStatus(KycRecoveryStatus newStatus) {
    var account = item;
    if(account != null) {
      account.kycRecoveryStatus = newStatus;
      storeItem(account);
      broadcast();
    }
  }

  updateRole(int newRoleId) {
    var account = item;
    if(account != null) {
      account.roleId = newRoleId;
      storeItem(account);
      broadcast();
    }
  }
}
