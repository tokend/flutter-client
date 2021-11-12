import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

import 'model/transaction_detail_item.dart';

class TransactionDetailsScreen extends BaseStatelessWidget {
  BalanceChange transaction;

  TransactionDetailsScreen(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        leading: IconButton(
          icon: Icon(CustomIcons.add, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'transaction_details'.tr,
          style:
              TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: TransactionDetail(transaction),
    );
  }
}

class TransactionDetail extends BaseStatelessWidget {
  BalanceChange transaction;

  TransactionDetail(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '${transaction.amount} ${transaction.assetCode}',
                  style: TextStyle(
                      color: context.colorTheme.accent,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 32.0)),
          Text(
            '${transaction.asset.name}',
            style: TextStyle(
              color: context.colorTheme.grayText,
              fontSize: 15.0,
            ),
          ),
          TransactionDetailItem(
              'type'.tr, transaction.cause.runtimeType.toString()),
          TransactionDetailItem(
              'operation'.tr, describeEnum(transaction.action).capitalize()),
          TransactionDetailItem('date'.tr,
              DateFormat('dd MMM yyyy, hh:mm').format(transaction.date)),
          TransactionDetailItem('fixed_fee'.tr,
              '${transaction.fee.fixed} ${transaction.assetCode}'),
          TransactionDetailItem('percent_fee'.tr,
              '${transaction.fee.percent} ${transaction.assetCode}'),
          TransactionDetailItem('total_fee'.tr,
              '${transaction.fee.total} ${transaction.assetCode}'),
          TransactionDetailItem('receiver'.tr, '${transaction.counterparty}'),
        ],
      ),
    );
  }
}
