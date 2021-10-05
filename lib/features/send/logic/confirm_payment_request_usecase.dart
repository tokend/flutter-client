import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/transaction.dart' as tr;
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/op_extensions/simple_payment_op.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/features/send/model/payment_request.dart';
import 'package:flutter_template/logic/tx_manager.dart';

class ConfirmPaymentRequestUseCase {
  PaymentRequest _request;
  AccountProvider _accountProvider;
  RepositoryProvider _repositoryProvider;
  TxManager _txManager;

  late NetworkParams _networkParams;
  late String _resultMetaXdr;

  ConfirmPaymentRequestUseCase(this._request, this._accountProvider,
      this._repositoryProvider, this._txManager);

  Future<void> perform() {
    return getNetworkParams()
        .then((networkParams) => this._networkParams = networkParams)
        .then((_) => getTransaction())
        .then((transaction) =>
            _txManager.submit(transaction, waitForIngest: false))
        .then((response) => this._resultMetaXdr = response!.resultMetaXdr!)
        .then((_) => updateRepositories());
  }

  Future<tr.Transaction> getTransaction() async {
    var operation = SimplePaymentOp.fromPubKeys(
      _request.senderBalanceId,
      _request.recipient.accountId,
      Int64(_networkParams.amountToPrecised(_request.amount.toDouble())),
      PaymentFeeData(
          _request.fee.senderFee.toXdrFee(_networkParams),
          _request.fee.recipientFee.toXdrFee(_networkParams),
          _request.fee.senderPaysForRecipient,
          PaymentFeeDataExtEmptyVersion()),
    );

    var transaction = await TransactionBuilder.FromPubKey(
            _networkParams, _request.senderAccountId)
        .addOperation(OperationBodyPayment(operation))
        .build();

    var account = _accountProvider.getAccount();
    if (account == null) {
      return Future.error(StateError('Cannot obtain current account'));
    }

    transaction.addSignature(account);

    return Future.value(transaction);
  }

  Future<NetworkParams> getNetworkParams() {
    return _repositoryProvider.systemInfo
        .getItem()
        .then((systemInfo) => systemInfo.toNetworkParams());
  }

  updateRepositories() {
    var balances = _repositoryProvider.balances;
    //TODO update balances and balance changes repositories
  }
}
