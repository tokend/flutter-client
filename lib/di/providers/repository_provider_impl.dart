import 'package:dcache/dcache.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persitence_on_prefs.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/extensions/lru_cache.dart';
import 'package:flutter_template/features/account/model/account_record.dart';
import 'package:flutter_template/features/account/storage/account_repository.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/logic/kyc_request_state_repository.dart';
import 'package:flutter_template/features/kyc/model/active_kyc.dart';
import 'package:flutter_template/features/kyc/storage/active_kyc_repository.dart';
import 'package:flutter_template/features/offers/storage/offers_repository.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/orderbook/storage/order_book_repository.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryProviderImpl implements RepositoryProvider {
  static const int MAX_SAME_REPOSITORIES_COUNT = 10;
  ApiProvider apiProvider;
  WalletInfoProvider walletInfoProvider;
  UrlConfigProvider urlConfigProvider;
  SharedPreferences? persistencePreferences;

  var chartRepositoriesByCode = LruCache(
      storage: InMemoryStorage<String, AssetChartRepository>(
          MAX_SAME_REPOSITORIES_COUNT));

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

  @override
  late AccountRepository account;

  @override
  late ActiveKycRepository activeKyc;

  @override
  late AssetPairsRepository assetPairsRepository;

  @override
  late OffersRepository offersRepository;

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
    account = AccountRepository(
        apiProvider, walletInfoProvider, getAccountRecordPersistence());
    activeKyc = ActiveKycRepository(
        account, blobs, keyValueEntriesRepository, getActiveKycPersistence());
    assetPairsRepository = AssetPairsRepository(apiProvider, urlConfigProvider);
    offersRepository = OffersRepository(
        apiProvider, walletInfoProvider, false); //TODO onlyPrimary
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

  ObjectPersistence<AccountRecord> getAccountRecordPersistence() {
    ObjectPersistence<AccountRecord> persistence =
        ObjectPersistenceOnPrefs<AccountRecord>(
            persistencePreferences!, "account_record");

    if (persistencePreferences != null) {
      persistence = ObjectPersistenceOnPrefs<AccountRecord>(
          persistencePreferences!, "account_record");
    } //TODO else case

    return persistence;
  }

  ObjectPersistence<ActiveKyc> getActiveKycPersistence() {
    ObjectPersistence<ActiveKyc> persistence =
        ObjectPersistenceOnPrefs<ActiveKyc>(
            persistencePreferences!, "kyc_form");

    if (persistencePreferences != null) {
      persistence = ObjectPersistenceOnPrefs<ActiveKyc>(
          persistencePreferences!, "kyc_form");
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

  @override
  AssetChartRepository assetChartsRepository(
      String baseAssetCode, String quoteAssetCode) {
    return chartRepositoriesByCode.getOrPut(
        '$baseAssetCode-$quoteAssetCode',
        new AssetChartRepository(
            this.apiProvider, baseAssetCode, quoteAssetCode));
  }

  @override
  OrderBookRepository orderBook(String baseAsset, String quoteAsset) {
    return OrderBookRepository(apiProvider, baseAsset, quoteAsset);
  }
}
