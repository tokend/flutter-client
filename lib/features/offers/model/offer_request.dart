import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';

class OfferRequest {
  int orderBookId;
  Decimal price;
  bool isBuy;
  Asset baseAsset;
  Asset quoteAsset;
  Decimal baseAmount;
  SimpleFeeRecord fee;
  OfferRecord? offerToCancel;
  late Decimal quoteAmount;

  OfferRequest(this.orderBookId, this.price, this.isBuy, this.baseAsset,
      this.quoteAsset, this.baseAmount, this.fee, this.offerToCancel) {
    quoteAmount = baseAmount * price;
  }
}
