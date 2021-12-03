import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persitence_on_prefs.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/logic/kyc_request_state_repository.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryProviderImpl implements RepositoryProvider {
  ApiProvider apiProvider;
  WalletInfoProvider walletInfoProvider;
  UrlConfigProvider urlConfigProvider;
  SharedPreferences? persistencePreferences;

  @override
  late var balances;

  @override
  late var assets;

  @override
  late var systemInfo;

  @override
  late BlobsRepository blobs;

  @override
  late KycRequestStateRepository kycRequestStateRepository;

  @override
  late KeyValueEntriesRepository keyValueEntriesRepository;

  RepositoryProviderImpl(
      {required this.apiProvider,
      required this.walletInfoProvider,
      required this.urlConfigProvider,
      this.persistencePreferences}) {
    balances =
        BalancesRepository(apiProvider, walletInfoProvider, urlConfigProvider);
    assets =
        AssetsRepository(apiProvider, walletInfoProvider, urlConfigProvider);
    systemInfo = SystemInfoRepository(apiProvider, getSystemInfoPersistence());
    blobs = BlobsRepository(apiProvider, walletInfoProvider);
    keyValueEntriesRepository = KeyValueEntriesRepository(apiProvider.getApi());
    kycRequestStateRepository = KycRequestStateRepository(
        apiProvider, walletInfoProvider, blobs, keyValueEntriesRepository);
  }

  ObjectPersistence<SystemInfoRecord> getSystemInfoPersistence() {
    ObjectPersistence<SystemInfoRecord> persistence =
        ObjectPersistenceOnPrefs<SystemInfoRecord>(
            persistencePreferences!, "system_info");

    if (persistencePreferences != null) {
      persistence = ObjectPersistenceOnPrefs<SystemInfoRecord>(
          persistencePreferences!, "system_info");
    } //TODO else case

    return persistence;
  }

  @override
  BalanceChangesRepository balanceChanges(String? balanceId) {
    return BalanceChangesRepository(
        balanceId,
        walletInfoProvider.getWalletInfo()?.accountId,
        apiProvider,
        MemoryOnlyPagedDataCache<BalanceChange>());
  }
}
