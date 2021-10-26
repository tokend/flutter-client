import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/view/balance_history.dart';

class BalanceHistoryScreen extends StatelessWidget {
  BalanceRecord balanceRecord;

  BalanceHistoryScreen(this.balanceRecord);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: context.colorTheme.background,
        title: Text(
          '${balanceRecord.asset.name} (${balanceRecord.asset.code})',
          style:
              TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BalanceHistory(balanceRecord),
    );
  }
}
