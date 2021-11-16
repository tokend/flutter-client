import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/history/view/model/transaction_detail_item.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AssetDetailsScreen extends StatelessWidget {
  AssetRecord assetRecord;

  AssetDetailsScreen(this.assetRecord);

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
      body: AssetDetail(this.assetRecord),
    );
  }
}

class AssetDetail extends StatelessWidget {
  AssetRecord assetRecord;

  AssetDetail(this.assetRecord);

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
          TransactionDetailItem(
              'maximum'.tr, '${assetRecord.maximum} ${assetRecord.code}'),
          TransactionDetailItem(
              'issued'.tr, '${assetRecord.issued} ${assetRecord.code}'),
          TransactionDetailItem(
              'available'.tr, '${assetRecord.available} ${assetRecord.code}'),
          TransactionDetailItem('transferable'.tr,
              '${assetRecord.isTransferable ? 'yes'.tr : 'no'.tr}'),
          TransactionDetailItem('withdrawable'.tr,
              '${assetRecord.isWithdrawable ? 'yes'.tr : 'no'.tr}'),
          TransactionDetailItem('base_in_atomic_swap'.tr,
              '${assetRecord.canBeBaseInAtomicSwap ? 'yes'.tr : 'no'.tr}'),
          TransactionDetailItem('quote_in_atomic_swap'.tr,
              '${assetRecord.canBeQuoteInAtomicSwap ? 'yes'.tr : 'no'.tr}'),
          TransactionDetailItem('deposit_method'.tr,
              '${assetRecord.isDepositable ? 'depositable'.tr : 'non_depositable'.tr}'),
        ],
      ),
    );
  }
}
