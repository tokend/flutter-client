import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';

abstract class RepositoryProvider {
  abstract SystemInfoRepository systemInfo;
  abstract BalancesRepository balances;
  abstract AssetsRepository assets;

  BalanceChangesRepository balanceChanges(String? balanceId);
}
