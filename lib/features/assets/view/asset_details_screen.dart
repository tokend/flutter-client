import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/history/view/model/transaction_detail_item.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

//TODO remove hardcode
class AssetDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        leading: IconButton(
          icon: Icon(CustomIcons.add, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'asset_details'.tr,
          style:
              TextStyle(color: context.colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: AssetDetail(),
    );
  }
}

class AssetDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'BTC',
                  style: TextStyle(
                      color: context.colorTheme.accent,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 32.0)),
          Text(
            'Bitcoin',
            style: TextStyle(
              color: context.colorTheme.grayText,
              fontSize: 15.0,
            ),
          ),
          TransactionDetailItem('maximum'.tr, '21,000,000 BTC'),
          TransactionDetailItem('issued'.tr, '26,000,000 BTC'),
          TransactionDetailItem('available'.tr, '26,000,000 BTC'),
          TransactionDetailItem('transferable'.tr, 'Yes'),
          TransactionDetailItem('withdrawable'.tr, 'No'),
          TransactionDetailItem('base_in_atomic_swap'.tr, 'No'),
          TransactionDetailItem('quote_in_atomic_swap'.tr, 'No'),
          TransactionDetailItem('deposit_method'.tr, 'Non-depositable'),
          TransactionDetailItem(
              'asset_type'.tr, 'Does not require verification'),
        ],
      ),
    );
  }
}
