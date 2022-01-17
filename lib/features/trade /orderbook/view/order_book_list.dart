import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/orderbook/model/order_book.dart';
import 'package:flutter_template/features/trade%20/orderbook/model/order_book_record.dart';
import 'package:flutter_template/features/trade%20/orderbook/storage/order_book_repository.dart';
import 'package:flutter_template/features/trade%20/orderbook/view/order_book_list_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class OrderBookList extends BaseStatefulWidget {
  bool isAsk;
  bool isFull;
  String baseAsset;
  String quoteAsset;

  OrderBookList(this.baseAsset, this.quoteAsset,
      {this.isAsk = true, this.isFull = true});

  @override
  State<OrderBookList> createState() => _OrderBookListState();
}

class _OrderBookListState extends State<OrderBookList> {
  @override
  Widget build(BuildContext context) {
    OrderBookRepository orderBookRepository = widget.repositoryProvider
        .orderBook(widget.baseAsset, widget.quoteAsset);
    var streamController;

    void subscribeToOrderBookRepository() async {
      await orderBookRepository.update();
    }

    subscribeToOrderBookRepository();

    streamController = orderBookRepository.streamSubject;

    return StreamBuilder<OrderBook>(
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<OrderBook> snapshot) {
          if (snapshot.data?.sellEntries.isEmpty == true &&
              orderBookRepository.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Container(
              height: 40.0,
              child: _emptyWidget(orderBookRepository),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            orderBookRepository.isNeverUpdated = false;

            var filteredItems = widget.isAsk
                ? snapshot.data!.sellEntries
                : snapshot.data!.buyEntries;

            return Container(
              color: context.colorTheme.background,
              child: _listWidget(orderBookRepository, filteredItems),
            );
          } else if (snapshot.hasError) {
            log(snapshot.stackTrace.toString());
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }

  Widget _listWidget(OrderBookRepository orderBookRepository,
      List<OrderBookRecord> filteredItems) {
    if (widget.isFull) {
      return RefreshIndicator(
        onRefresh: () {
          return orderBookRepository.update();
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                      left: widget.isFull ? 16.0 : 0.0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.isFull == true ? filteredItems.length : 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Builder(
                        builder: (BuildContext context) =>
                            OrderBookListItem(filteredItems[index]));
                  }),
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    right: 16.0,
                    left: widget.isFull ? 16.0 : 0.0),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.isFull == true ? filteredItems.length : 1,
                itemBuilder: (BuildContext context, int index) {
                  return Builder(
                      builder: (BuildContext context) =>
                          OrderBookListItem(filteredItems[index]));
                }),
          ),
        ),
      );
    }
  }

  Widget _emptyWidget(OrderBookRepository orderBookRepository) {
    if (widget.isFull) {
      return RefreshIndicator(
        onRefresh: () {
          return orderBookRepository.update();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
              child: Text(
                'empty_offers_list'.tr,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            height: 40.0,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Text(
              'empty_offers_list'.tr,
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          height: 40.0,
        ),
      );
    }
  }
}
