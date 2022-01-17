import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/orderbook/view/order_book_list.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class OrderBookScreen extends BaseStatefulWidget {
  String baseAsset;
  String quoteAsset;
  bool isAsks;

  OrderBookScreen(this.baseAsset, this.quoteAsset, this.isAsks);

  @override
  State<OrderBookScreen> createState() => _OrderBookScreenState();
}

class _OrderBookScreenState extends State<OrderBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'asks'.tr,
          style:
              TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: OrderBookList(
        widget.baseAsset,
        widget.quoteAsset,
        isFull: true,
        isAsk: widget.isAsks,
      ),
    );
  }
}
