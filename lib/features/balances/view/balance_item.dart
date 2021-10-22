import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/view/balance_history_screen.dart';

class BalanceItem extends StatelessWidget {
  BalanceRecord balanceRecord;

  BalanceItem(this.balanceRecord);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorTheme.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (BuildContext context) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BalanceHistoryScreen(balanceRecord)));
          },
          child: ListTile(
            minLeadingWidth: 12,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(
                'https://picsum.photos/250?image=9', //TODO
                height: 36.0,
                width: 36.0,
              ),
            ),
            title: GestureDetector(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${balanceRecord.asset.name} (${balanceRecord.asset.code})',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                  Row(
                    children: [
                      Text(
                          '${balanceRecord.available} ${balanceRecord.asset.code}',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  )
                ],
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_right), //TODO add custom icon
          ),
        ),
      ),
    );
  }
}
