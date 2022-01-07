import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/history/view/trade_history_list.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TradeHistoryScreen extends BaseStatefulWidget {
  String baseAsset;
  String quoteAsset;

  TradeHistoryScreen(this.baseAsset, this.quoteAsset);

  @override
  State<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        leading: IconButton(
          icon: Icon(CustomIcons.back_square, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'trade_history'.tr,
          style:
              TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: TradeHistoryList(
        widget.baseAsset,
        widget.quoteAsset,
        isFull: true,
      ),
    );
  }
}
