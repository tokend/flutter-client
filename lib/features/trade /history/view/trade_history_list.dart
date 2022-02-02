import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/history/model/trade_history_record.dart';
import 'package:flutter_template/features/trade%20/history/storage/trade_history_repository.dart';
import 'package:flutter_template/features/trade%20/history/view/trade_history_list_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TradeHistoryList extends BaseStatefulWidget {
  String baseAsset;
  String quoteAsset;
  bool isFull;
  bool addPadding;

  TradeHistoryList(this.baseAsset, this.quoteAsset,
      {this.isFull = true, this.addPadding = true});

  @override
  State<TradeHistoryList> createState() => _TradeHistoryListState();
}

class _TradeHistoryListState extends State<TradeHistoryList> {
  @override
  Widget build(BuildContext context) {
    TradeHistoryRepository tradeHistoryRepository = widget.repositoryProvider
        .tradeHistoryRepository(widget.baseAsset, widget.quoteAsset);
    var streamController;

    void subscribeToTradeHistory() async {
      await tradeHistoryRepository.update();
      tradeHistoryRepository.isNeverUpdated = false;
    }

    if (tradeHistoryRepository.isNeverUpdated) {
      subscribeToTradeHistory();
    }

    streamController = tradeHistoryRepository.streamController;

    return StreamBuilder<List<TradeHistoryRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<TradeHistoryRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              tradeHistoryRepository.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Container(
              height:
                  widget.addPadding ? MediaQuery.of(context).size.height : 40.0,
              child: _emptyWidget(tradeHistoryRepository),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            tradeHistoryRepository.isNeverUpdated = false;

            return Container(
              color: context.colorTheme.background,
              child: _listWidget(tradeHistoryRepository, snapshot.data!),
            );
          } else if (snapshot.hasError) {
            log(snapshot.stackTrace.toString());
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Container(
              color: context.colorTheme.background,
              child: widget.isFull
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Text('loading'.tr),
                    ));
        });
  }

  Widget _listWidget(TradeHistoryRepository tradeHistoryRepository,
      List<TradeHistoryRecord> data) {
    if (widget.isFull) {
      return RefreshIndicator(
        onRefresh: () {
          return tradeHistoryRepository.update();
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ListView.separated(
                padding: EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    right: 16.0,
                    left: widget.addPadding ? 16.0 : 0.0),
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 2),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.isFull == true ? data.length : 2,
                itemBuilder: (BuildContext context, int index) {
                  return Builder(
                      builder: (BuildContext context) =>
                          TradeHistoryListItem(data[index]));
                }),
          ),
        ),
      );
    } else {
      return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              right: 16.0,
              left: widget.addPadding ? 16.0 : 0.0),
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 2),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.isFull == true
              ? data.length
              : data.length > 1
                  ? 2
                  : 1,
          itemBuilder: (BuildContext context, int index) {
            return Builder(
                builder: (BuildContext context) =>
                    TradeHistoryListItem(data[index]));
          });
    }
  }

  Widget _emptyWidget(TradeHistoryRepository tradeHistoryRepository) {
    if (widget.isFull) {
      return RefreshIndicator(
        onRefresh: () {
          return tradeHistoryRepository.update();
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
            height:
                widget.addPadding ? MediaQuery.of(context).size.height : 40.0,
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
