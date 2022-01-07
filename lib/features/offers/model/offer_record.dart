import 'dart:typed_data';

import 'package:dart_wallet/base32check.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

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
  late String baseBalanceId;
  late String quoteBalanceId;
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
    baseBalanceId = EMPTY_BALANCE_ID;
    quoteBalanceId = EMPTY_BALANCE_ID;
  }

  OfferRecord.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        baseAsset = SimpleAsset(
            json['relationships']['base_asset']['data']['id'], '', 6),
        quoteAsset = SimpleAsset(
            json['relationships']['quote_asset']['data']['id'], '', 6),
        price = Decimal.parse(json['attributes']['price']),
        isBuy = json['attributes']['is_buy'],
        baseAmount = Decimal.parse(json['attributes']['base_amount']),
        quoteAmount = Decimal.parse(json['attributes']['quote_amount']),
        fee = SimpleFeeRecord.fromJson(json['attributes']['fee']),
        date = DateTime.parse(json['attributes']['created_at']),
        orderBookId = int.parse(json['attributes']['order_book_id']),
        baseBalanceId = json['relationships']['base_balance']['data']['id'],
        quoteBalanceId = json['relationships']['quote_balance']['data']['id'];

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is OfferRecord && other.id == this.id;
  }
}
