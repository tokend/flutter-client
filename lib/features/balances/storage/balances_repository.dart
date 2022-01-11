import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction.dart' as Tr;
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/op_extensions/create_balance_op.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/model/account_params.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:get/get.dart';

class BalancesRepository extends MultipleItemsRepository<BalanceRecord> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;
  UrlConfigProvider _urlConfigProvider;

  BalancesRepository(
      this._apiProvider, this._walletInfoProvider, this._urlConfigProvider);

  @override
  Future<List<BalanceRecord>> getItems() async {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null)
      return Future.error(StateError('No signed API instance found'));
    _walletInfoProvider = Get.find();
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));

    var itemsList = signedApi
        .getService()
        .get('v3/accounts/$accountId',
            query: AccountParams(List.of([
              AccountParams.BALANCES,
              AccountParams.BALANCES_STATE,
              AccountParams.BALANCES_ASSET,
            ])).map())
        .then((response) {
      var included =
          json.decode(json.encode(response['included'])) as List<dynamic>;
      log(included.runtimeType.toString());
      var balances = included.where((include) => include['type'] == 'balances');
      var assets = included.where((include) => include['type'] == 'assets');
      var balancesStates =
          included.where((include) => include['type'] == 'balances-state');
      return balances
          .map((balance) => BalanceRecord(
              balance['id'],
              AssetRecord.fromJson(
                  assets.firstWhere((asset) =>
                      asset['id'] ==
                      balance['relationships']['asset']['data']['id']),
                  _urlConfigProvider.getConfig()),
              Decimal.parse(balancesStates.firstWhere((state) =>
                  state['id'] ==
                  balance['relationships']['state']['data']
                      ['id'])['attributes']['available'])))
          .toList();
    });

    streamSubject.sink.add((await itemsList));
    return itemsList;
  }

  /// Creates balance for given assets,
  /// updates repository on complete
  Future<void> create(
      AccountProvider accountProvider,
      SystemInfoRepository systemInfoRepository,
      TxManager txManager,
      List<String> assets) async {
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    var account = accountProvider.getAccount();
    if (accountId == null || account == null)
      return Future.error(StateError('No wallet info found'));

    var netParams = (await systemInfoRepository.getItem()).toNetworkParams();
    return createBalanceCreationTransaction(
            netParams, accountId, account, assets)
        .then((transaction) => txManager.submit(transaction));
  }

  Future<Tr.Transaction> createBalanceCreationTransaction(
    NetworkParams networkParams,
    String sourceAccountId,
    Account signer,
    List<String> assets,
  ) {
    var operations = assets
        .map((asset) => CreateBalanceOp.FromPubKey(sourceAccountId, asset));
    return TransactionBuilder(
            networkParams, PublicKeyFactory.fromAccountId(sourceAccountId))
        .addOperations(
            operations.map((e) => OperationBodyManageBalance(e)).toList())
        .addSigner(signer)
        .build();
  }
}
