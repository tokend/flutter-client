import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

import 'order_book_record.dart';

class OrderBook {
  String id;
  late List<OrderBookRecord> buyEntries;
  late List<OrderBookRecord> sellEntries;
  Asset baseAsset;
  Asset quoteAsset;

  OrderBook.fromJson(
    Map<String, dynamic> data,
    List<dynamic> included,
  )   : id = data['id'],
        baseAsset = SimpleAsset.simpleModel(
            data['relationships']['base_asset']['data']),
        quoteAsset = SimpleAsset.simpleModel(
            data['relationships']['quote_asset']['data']) {
    buyEntries = getEntries(included, true);
    sellEntries = getEntries(included, false);
  }

  List<OrderBookRecord> getEntries(List<dynamic> json, bool isBuy) {
    return json
        .where((element) =>
            element['type'] == 'order-book-entries' &&
            element['attributes']['is_buy'] == isBuy)
        .map((include) => OrderBookRecord.fromJson(include))
        .toList();
  }
}
