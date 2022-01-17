import 'package:decimal/decimal.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class OrderBookRecord {
  Decimal price;
  Decimal volume;
  Asset baseAsset;
  Asset quoteAsset;
  bool isBuy;

  OrderBookRecord(
      this.price, this.volume, this.baseAsset, this.quoteAsset, this.isBuy);

  OrderBookRecord.fromJson(Map<String, dynamic> json)
      : price = Decimal.parse(json['attributes']['price']),
        volume = Decimal.parse(json['attributes']['cumulative_base_amount']),
        baseAsset = SimpleAsset.simpleModel(
            json['relationships']['base_asset']['data']),
        quoteAsset = SimpleAsset.simpleModel(
            json['relationships']['quote_asset']['data']),
        isBuy = json['attributes']['is_buy'];
}
