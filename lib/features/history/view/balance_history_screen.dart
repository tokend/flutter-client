import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/view/balance_history.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class BalanceHistoryScreen extends StatelessWidget {
  BalanceRecord balanceRecord;
  bool isMovementsScreen;
  bool isMyBalancesScreen;

  BalanceHistoryScreen(
      this.balanceRecord, this.isMovementsScreen, this.isMyBalancesScreen);

  @override
  Widget build(BuildContext context) {
    var body = Container(
        color: context.colorTheme.background,
        child: BalanceHistory(balanceRecord));
    var appbarTitle = 'latest_activity'.tr;
    if (isMovementsScreen) {
      appbarTitle = '${balanceRecord.asset.name} (${balanceRecord.asset.code})';
    } else if (isMyBalancesScreen) {
      appbarTitle = '${balanceRecord.asset.name} (${balanceRecord.asset.code})';
      //TODO body
    }
    return Container(
        color: context.colorTheme.background,
        height: double.infinity,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.colorTheme.accent),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: context.colorTheme.background,
            title: Text(
              appbarTitle,
              style: TextStyle(
                  color: context.colorTheme.headerText, fontSize: 17.0),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: body,
        ));
  }
}
