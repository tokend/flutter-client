import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/logic/kyc_request_state_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';

abstract class RepositoryProvider {
  abstract SystemInfoRepository systemInfo;
  abstract BalancesRepository balances;
  abstract AssetsRepository assets;
  abstract BlobsRepository blobs;
  abstract KycRequestStateRepository kycRequestStateRepository;
  abstract KeyValueEntriesRepository keyValueEntriesRepository;

  BalanceChangesRepository balanceChanges(String? balanceId);
}
