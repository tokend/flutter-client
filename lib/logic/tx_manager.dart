import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction.dart' as tr;
import 'package:dart_wallet/transaction_builder.dart' as tr;
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_template/di/providers/api_provider.dart';

class TxManager {
  ApiProvider _apiProvider;

  TxManager(this._apiProvider);

  Future<SubmitTransactionResponse?> submit(tr.Transaction transaction,
      {waitForIngest = true}) {
    return _apiProvider
        .getApi()
        .transactions
        .submitTransaction(transaction, waitForIngest);
  }

  static Future<tr.Transaction> createSignedTransaction(
      NetworkParams networkParams,
      String sourceAccountId,
      Account signer,
      List<OperationBody> operations) {
    var transaction = tr.TransactionBuilder(
            networkParams, PublicKeyFactory.fromAccountId(sourceAccountId))
        .addOperations(operations.toList())
        .addSigner(signer)
        .build();
    return transaction;
  }
}
