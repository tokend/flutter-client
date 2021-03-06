import 'package:decimal/decimal.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class TradeHistoryRecord {
  String id;
  Asset baseAsset;
  Asset quoteAsset;
  Decimal baseAmount;
  Decimal quoteAmount;
  Decimal price;
  DateTime createdAt;
  bool hasPositiveTrend;

  TradeHistoryRecord(
    this.id,
    this.baseAsset,
    this.quoteAsset,
    this.baseAmount,
    this.quoteAmount,
    this.price,
    this.createdAt,
    this.hasPositiveTrend,
  );

  TradeHistoryRecord.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        baseAsset = SimpleAsset.simpleModel(
            json['relationships']['base_asset']['data']),
        quoteAsset = SimpleAsset.simpleModel(
            json['relationships']['quote_asset']['data']),
        baseAmount = Decimal.parse(json['attributes']['base_amount']),
        quoteAmount = Decimal.parse(json['attributes']['quote_amount']),
        price = Decimal.parse(json['attributes']['quote_amount']),
        createdAt = DateTime.parse(json['attributes']['created_at']),
        hasPositiveTrend = true;

  @override
  bool operator ==(Object other) {
    other as TradeHistoryRecord;
    if (id != other.id) return false;
    if (hasPositiveTrend != other.hasPositiveTrend) return false;

    return true;
  }

  @override
  int get hashCode {
    var result = id.hashCode;
    result = 31 * result + hasPositiveTrend.hashCode;
    return result;
  }
}
