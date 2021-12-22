import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class OrderBook {
  String id;
  late Map<String, dynamic> buyEntries;
  late Map<String, dynamic> sellEntries;
  Asset baseAsset;
  Asset quoteAsset;

  OrderBook.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        baseAsset = SimpleAsset(
            json['relationships']['base_asset']['data']['id'], null, 6),
        quoteAsset = SimpleAsset(
            json['relationships']['quote_asset']['data']['id'], null, 6) {
    buyEntries = getEntries(json['relationships'], true);
    sellEntries = getEntries(json['relationships'], false);
  }

  Map<String, dynamic> getEntries(Map<String, dynamic> json, bool isBuy) {
    Map<String, dynamic> entries;
    if (isBuy)
      entries = json['buy_entries'];
    else
      entries = json['sell_entries'];

    return entries;
  }
}
