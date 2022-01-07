import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/assets/view/asset_details_screen.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AssetItem extends StatelessWidget {
  AssetRecord assetRecord;
  BalanceRecord? relatedBalance;

  AssetItem(this.assetRecord, {this.relatedBalance});

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
                    builder: (context) => AssetDetailsScreen(assetRecord)));
          },
          child: ListTile(
            minLeadingWidth: 12,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                width: 36.0,
                height: 36.0,
                child: assetRecord.logoUrl != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          height: 36.0,
                          width: 36.0,
                          child: Icon(CustomIcons.bitcoin__btc_),
                        ),
                        imageUrl: assetRecord.logoUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 36.0,
                        width: 36.0,
                        child: Icon(CustomIcons.bitcoin__btc_),
                      ),
              ),
            ),
            title: GestureDetector(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${assetRecord.name} (${assetRecord.code})',
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
                          relatedBalance == null
                              ? 'no_balance'.tr
                              : '${relatedBalance!.available} ${relatedBalance!.asset.code}',
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
