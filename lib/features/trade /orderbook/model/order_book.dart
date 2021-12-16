import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/trade%20/orderbook/model/order_book_record.dart';

class OrderBook {
  String id;
  late List<OrderBookRecord> buyEntries;
  late List<OrderBookRecord> sellEntries;
  Asset baseAsset;
  Asset quoteAsset;

  OrderBook.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sellEntries = json['sell_entries'],
        baseAsset = json['base_asset'],
        quoteAsset = json['quote_asset'] {
    buyEntries = getEntries(json, true);
    sellEntries = getEntries(json, false);
  }

  List<OrderBookRecord> getEntries(Map<String, dynamic> json, bool isBuy) {
    List<Map<String, dynamic>> entries;
    if (isBuy)
      entries = json['buy_entries'].toList();
    else
      entries = json['sell_entries'].toList();

    return entries.map((entry) => OrderBookRecord.fromJson(entry)).toList();
  }
}
