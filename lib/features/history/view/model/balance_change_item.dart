import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/view/transaction_details_screen.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:intl/intl.dart';

class BalanceChangeItem extends StatelessWidget {
  BalanceChange balanceChange;

  BalanceChangeItem(this.balanceChange);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorTheme.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (BuildContext context) => ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              'https://picsum.photos/250?image=9', //TODO
              height: 36.0,
              width: 36.0,
            ),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${balanceChange.cause.runtimeType.toString()}',
                      //TODO change to appropriate strings
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                ),
                Row(
                  children: [
                    Text('${describeEnum(balanceChange.action)}'.capitalize(),
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '${DateFormat('dd MMM yyyy').format(balanceChange.date)}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                ),
                Row(
                  children: [
                    Text(
                        '${balanceChange.amount} ${balanceChange.asset.code.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                )
              ],
            ),
          ]),
          trailing: null,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TransactionDetailsScreen(balanceChange)));
          },
        ),
      ),
    );
  }
}
