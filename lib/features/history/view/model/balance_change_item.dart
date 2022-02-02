import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';
import 'package:flutter_template/features/history/model/balance_change_cause.dart';
import 'package:flutter_template/features/history/view/transaction_details_screen.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class BalanceChangeItem extends StatelessWidget {
  BalanceChange balanceChange;

  BalanceChangeItem(this.balanceChange);

  @override
  Widget build(BuildContext context) {
    var currentItemView = getIconData(balanceChange, context);
    return Card(
      color: context.colorTheme.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (BuildContext context) => ListTile(
          leading: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: Container(
              height: 36.0,
              width: 36.0,
              color: currentItemView.item1,
              child: Icon(
                currentItemView.item3,
                color: currentItemView.item2,
              ),
            ),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

///Returns backgroundColor, iconTint, icon depending on balance change cause
Tuple3<Color, Color, IconData> getIconData(
    BalanceChange balanceChange, BuildContext context) {
  var colourScheme = context.colorTheme;
  if (balanceChange.cause is Payment) {
    return Tuple3(colourScheme.errorRejectAlertLight,
        colourScheme.errorRejectAlert, CustomIcons.money_send);
  } else if (balanceChange.cause is Offer) {
    return Tuple3(
        colourScheme.yellowLight, colourScheme.yellow, CustomIcons.lock_slash);
  } else if (balanceChange.cause is SaleCancellation) {
    return Tuple3(colourScheme.approvedLight, colourScheme.approved,
        CustomIcons.money_recive);
  } else if (balanceChange.cause is Issuance) {
    // TODO all types
  }
  return Tuple3(
      colourScheme.yellowLight, colourScheme.yellow, CustomIcons.money_recive);
}
