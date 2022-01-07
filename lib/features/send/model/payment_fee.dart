import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';

class PaymentFee {
  SimpleFeeRecord senderFee;
  SimpleFeeRecord recipientFee;
  bool senderPaysForRecipient = false;

  PaymentFee(this.senderFee, this.recipientFee, this.senderPaysForRecipient);

  Decimal get totalPercentSenderFee =>
      senderFee.percent +
      (senderPaysForRecipient ? recipientFee.percent : Decimal.zero);

  Decimal get totalFixedSenderFee =>
      senderFee.fixed +
      (senderPaysForRecipient ? recipientFee.fixed : Decimal.zero);

  Decimal get totalSenderFee => totalFixedSenderFee + totalPercentSenderFee;
}
