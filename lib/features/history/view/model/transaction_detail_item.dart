import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';

class TransactionDetailItem extends StatelessWidget {
  String label;
  String value;

  TransactionDetailItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 14.0)),
        Text(
          '$label',
          style: TextStyle(
            color: context.colorTheme.grayText,
            fontSize: 12.0,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 4.0)),
        Text(
          '$value',
          style: TextStyle(
            color: context.colorTheme.headerText,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Divider(height: 2),
      ],
    );
  }
}
