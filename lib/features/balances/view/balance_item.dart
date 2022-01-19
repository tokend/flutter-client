import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/history/view/balance_history_screen.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';

class BalanceItem extends StatelessWidget {
  BalanceRecord balanceRecord;
  bool isMovementsScreen;
  bool isMyBalancesScreen;

  BalanceItem(
      this.balanceRecord, this.isMovementsScreen, this.isMyBalancesScreen);

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
                    builder: (context) => BalanceHistoryScreen(
                        balanceRecord, isMovementsScreen, isMyBalancesScreen)));
          },
          child: ListTile(
            minLeadingWidth: 12,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                width: 36.0,
                height: 36.0,
                child: balanceRecord.asset.logoUrl != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          height: 36.0,
                          width: 36.0,
                          child: Icon(CustomIcons.bitcoin__btc_),
                        ),
                        imageUrl: balanceRecord.asset.logoUrl!,
                        fit: BoxFit.cover,
                      )
                    : CircularProfileAvatar(
                        '',
                        initialsText: Text(balanceRecord.asset.code
                            .substring(0, 1)
                            .capitalize()),
                      ),
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
