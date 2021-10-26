import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/view/balance_history.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class BalanceHistoryScreen extends StatelessWidget {
  BalanceRecord balanceRecord;
  bool isMovementsScreen;

  BalanceHistoryScreen(this.balanceRecord, this.isMovementsScreen);

  @override
  Widget build(BuildContext context) {
    var appbarTitle = 'latest_activity'.tr;
    if (isMovementsScreen) {
      appbarTitle = '${balanceRecord.asset.name} (${balanceRecord.asset.code})';
    }
    return Container(
      color: context.colorTheme.background,
      height: double.infinity,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            //TODO change on custom icon
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: context.colorTheme.background,
          title: Text(
            appbarTitle,
            style:
                TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BalanceHistory(balanceRecord),
      ),
    );
  }
}
