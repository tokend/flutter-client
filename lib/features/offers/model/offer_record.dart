import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:dart_wallet/base32check.dart';

class OfferRecord {
  int id;
  Asset baseAsset;
  Asset quoteAsset;
  Decimal price;
  bool isBuy;
  Decimal baseAmount;
  int orderBookId;
  DateTime date;
  SimpleFeeRecord fee;
  OfferRecord? offerToCancel;

  late Decimal quoteAmount;

  static String EMPTY_BALANCE_ID = Base32Check.encodeBalanceId(
      Uint8List.fromList(List.generate(32, (_) => 0)));

  bool get isInvestment => orderBookId != 0;

  OfferRecord(
    this.baseAsset,
    this.quoteAsset,
    this.price,
    this.isBuy,
    this.baseAmount,
    this.fee,
    this.offerToCancel,
    this.date, {
    this.id = 0,
    this.orderBookId = 0,
  }) {
    quoteAmount = baseAmount * price;
  }

  OfferRecord.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        baseAsset = json['base_asset'],
        quoteAsset = json['quote_asset'],
        price = json['price'],
        isBuy = json['is_buy'],
        baseAmount = json['base_amount'],
        quoteAmount = json['quote_amount'],
        fee = json['fee'],
        date = json['created_at'],
        orderBookId = json['order_book_id'];

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is OfferRecord && other.id == this.id;
  }
}
