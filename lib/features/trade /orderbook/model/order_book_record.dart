import 'package:decimal/decimal.dart';
import 'package:flutter_template/features/assets/model/asset.dart';

class OrderBookRecord {
  Decimal price;
  Decimal volume;
  Asset baseAsset;
  Asset quoteAsset;
  bool isBuy;

  OrderBookRecord(
      this.price, this.volume, this.baseAsset, this.quoteAsset, this.isBuy);

  OrderBookRecord.fromJson(Map<String, dynamic> json)
      : price = json['price'],
        volume = json['cumulative_base_amount'],
        baseAsset = json['base_asset'],
        quoteAsset = json['quote_asset'],
        isBuy = json['is_buy'];
}
