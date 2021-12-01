import 'package:dcache/dcache.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persitence_on_prefs.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/extensions/lru_cache.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
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
  late AssetPairsRepository assetPairsRepository;

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
    assetPairsRepository = AssetPairsRepository(apiProvider, urlConfigProvider);
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

  @override
  AssetChartRepository assetChartsRepository(
      String baseAssetCode, String quoteAssetCode) {
    return chartRepositoriesByCode.getOrPut('$baseAssetCode-$quoteAssetCode',
        new AssetChartRepository(this.apiProvider, baseAssetCode, quoteAssetCode));
  }
}
