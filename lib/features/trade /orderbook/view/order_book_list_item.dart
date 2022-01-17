import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/extensions/strings.dart';
import 'package:flutter_template/features/trade%20/orderbook/model/order_book_record.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class OrderBookListItem extends StatelessWidget {
  OrderBookRecord _orderBookRecord;

  OrderBookListItem(this._orderBookRecord);

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
                    'want'.tr.format([_orderBookRecord.baseAsset.code]),
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_orderBookRecord.volume}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'price_trade'.tr.format([_orderBookRecord.quoteAsset.code]),
                    style: leftTextStyle,
                  ),
                  Text(
                    '${_orderBookRecord.price}',
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
