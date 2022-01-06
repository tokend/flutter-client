import 'package:flutter_template/features/account/storage/account_repository.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/history/storage/balance_changes_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/logic/kyc_request_state_repository.dart';
import 'package:flutter_template/features/kyc/storage/active_kyc_repository.dart';
import 'package:flutter_template/features/offers/storage/offers_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/history/storage/trade_history_repository.dart';
import 'package:flutter_template/features/trade%20/orderbook/storage/order_book_repository.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';

abstract class RepositoryProvider {
  abstract SystemInfoRepository systemInfo;
  abstract AccountRepository account;
  abstract ActiveKycRepository activeKyc;
  abstract BalancesRepository balances;
  abstract AssetsRepository assets;
  abstract AssetPairsRepository assetPairsRepository;
  abstract BlobsRepository blobs;
  abstract KycRequestStateRepository kycRequestStateRepository;
  abstract KeyValueEntriesRepository keyValueEntriesRepository;
  abstract OffersRepository offersRepository;

  AssetChartRepository assetChartsRepository(
    String baseAsset,
    String quoteAsset,
  );

  BalanceChangesRepository balanceChanges(String? balanceId);

  OrderBookRepository orderBook(
    String baseAsset,
    String quoteAsset,
  );

  TradeHistoryRepository tradeHistoryRepository(
    String baseAsset,
    String quoteAsset,
  );
}
