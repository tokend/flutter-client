import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountIdScreen extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    WalletInfoProvider walletInfoProvider = Get.find();

    var accountId = walletInfoProvider.getWalletInfo()?.accountId.toUpperCase();
    return Scaffold(
      backgroundColor: context.colorTheme.background,
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        iconTheme: IconThemeData(color: context.colorTheme.accent),
        title: Text(
          'account_id'.tr,
          style: TextStyle(
              color: context.colorTheme.primaryText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 67.0),
            child: QrImage(
              data: accountId!,
              size: 200.0,
            ),
          ),
          Text(
            'account_id'.tr,
            style:
                TextStyle(color: context.colorTheme.grayText, fontSize: 12.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          Container(
            color: context.colorTheme.primaryLight,
            child: ListTile(
              title: Text(
                '$accountId',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: context.colorTheme.primary,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700),
              ),
              trailing: Icon(CustomIcons.copy),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: accountId));
                toastManager.showShortToast('data_copied'.tr);
              },
            ),
          )
        ]),
      ),
    );
  }
}
