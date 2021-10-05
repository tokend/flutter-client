import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';

abstract class RepositoryProvider {
  abstract SystemInfoRepository systemInfo;
  abstract BalancesRepository balances;
}
