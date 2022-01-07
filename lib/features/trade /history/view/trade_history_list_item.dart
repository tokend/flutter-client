import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/dates.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/history/model/trade_history_record.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TradeHistoryListItem extends StatelessWidget {
  TradeHistoryRecord _tradeHistoryRecord;

  TradeHistoryListItem(this._tradeHistoryRecord);

  @override
  Widget build(BuildContext context) {
    var colorTheme = context.colorTheme;
    var leftTextStyle = TextStyle(fontSize: 12.0, color: colorTheme.headerText);
    var rightTextStyle = TextStyle(
        fontSize: 13.0,
        color: colorTheme.headerText,
        fontWeight: FontWeight.w700);
    return Container(
      child: Card(
        color: colorTheme.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'amount_trade'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_tradeHistoryRecord.baseAmount}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'price_trade'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_tradeHistoryRecord.price}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total_trade'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_tradeHistoryRecord.quoteAmount}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'time'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_tradeHistoryRecord.createdAt.format(FULL_DATE_AND_TIME)}',
                    style: rightTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
