import 'dart:convert';

import 'package:dart_sdk/utils/extensions/random.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/send/model/payment_fee.dart';
import 'package:flutter_template/features/send/model/payment_recipient.dart';

class PaymentRequest {
  Decimal amount;
  Asset asset;
  String senderAccountId;
  String senderBalanceId;
  PaymentRecipient recipient;
  PaymentFee fee;
  String? paymentSubject;
  String reference = base64Encode(List.of(getSecureRandomSeed(16)));

  PaymentRequest(this.amount, this.asset, this.senderAccountId,
      this.senderBalanceId, this.recipient, this.fee, this.paymentSubject);
}
