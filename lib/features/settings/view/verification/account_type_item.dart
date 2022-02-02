import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';

class AccountTypeItem extends StatelessWidget {
  String accountType;
  String accountDescription;

  AccountTypeItem(this.accountType, this.accountDescription);

  @override
  Widget build(BuildContext context) {
    var colourScheme = context.colorTheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 104.0,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 38.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountType,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: colourScheme.primaryText),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                ),
                Text(
                  accountDescription,
                  style:
                      TextStyle(fontSize: 17.0, color: colourScheme.grayText),
                ),
              ],
            ),
          )),
    );
  }
}
