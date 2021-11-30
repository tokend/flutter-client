import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';

abstract class RepositoryProvider {
  abstract SystemInfoRepository systemInfo;
  abstract BalancesRepository balances;
  abstract AssetsRepository assets;
  abstract AssetPairsRepository assetPairsRepository;

  AssetChartRepository assetChartsRepository(
    String baseAsset,
    String quoteAsset,
  );

  BalanceChangesRepository balanceChanges(String? balanceId);
}
