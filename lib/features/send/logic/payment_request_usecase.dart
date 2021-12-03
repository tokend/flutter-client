import 'package:decimal/decimal.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/send/model/payment_fee.dart';
import 'package:flutter_template/features/send/model/payment_recipient.dart';
import 'package:flutter_template/features/send/model/payment_request.dart';

class CreatePaymentRequestUseCase {
  PaymentRecipient _recipient;
  Decimal _amount;
  BalanceRecord _balanceRecord;
  String? _subject;
  PaymentFee _paymentFee;
  WalletInfoProvider _walletInfoProvider;

  late String _senderAccount;

  CreatePaymentRequestUseCase(
      this._recipient,
      this._amount,
      this._balanceRecord,
      this._subject,
      this._paymentFee,
      this._walletInfoProvider);

  Future<PaymentRequest?> perform() {
    return _getSenderAccount().then((senderAccount) {
      if (senderAccount == _recipient.accountId)
        throw SendToYourselfException();

      this._senderAccount = senderAccount;
    }).then((_) => getPaymentRequest());
  }

  Future<String> _getSenderAccount() {
    var accId = _walletInfoProvider.getWalletInfo()?.accountId;

    if (accId == null) {
      return Future.error(StateError('Missing account ID'));
    }

    return Future.value(accId);
  }

  Future<PaymentRequest> getPaymentRequest() {
    return Future.value(PaymentRequest(_amount, _balanceRecord.asset,
        _senderAccount, _balanceRecord.id, _recipient, _paymentFee, _subject));
  }
}

class SendToYourselfException implements Exception {}
