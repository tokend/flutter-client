import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:lazy_evaluation/lazy_evaluation.dart';

abstract class RepositoryProvider {
  abstract Lazy<SystemInfoRepository> systemInfo;
  abstract Lazy<BalancesRepository> balances;

  BalanceChangesRepository balanceChanges(String? balanceId);
}
