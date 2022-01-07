import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/model/account_params.dart';
import 'package:flutter_template/features/account/model/account_record.dart';
import 'package:flutter_template/features/account/model/resolved_account_role.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';

class AccountRepository extends SingleItemRepository<AccountRecord> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;
  KeyValueEntriesRepository _keyValueEntriesRepository;
  ObjectPersistence<AccountRecord>? itemPersistence;

  AccountRepository(this._apiProvider, this._walletInfoProvider,
      this._keyValueEntriesRepository, this.itemPersistence);

  @override
  Future<AccountRecord> getItem() async {
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));
    var signedApi = _apiProvider.getSignedApi();

    var response = await signedApi.getService().get('v3/accounts/$accountId',
        query: AccountParams(List.of([AccountParams.KYC_DATA])).map());

    await _keyValueEntriesRepository.update();
    var items = AccountRecord.fromJson(
        response, _keyValueEntriesRepository.streamSubject.stream.value);
    streamSubject.add(items);

    return items;
  }

  updateKycRecoveryStatus(KycRecoveryStatus newStatus) {
    var account = item;
    if (account != null) {
      account.kycRecoveryStatus = newStatus;
      storeItem(account);
      broadcast();
    }
  }

  updateRole(ResolvedAccountRole newRole) {
    var account = item;
    if (account != null) {
      account.role = newRole;
      storeItem(account);
      broadcast();
    }
  }
}
