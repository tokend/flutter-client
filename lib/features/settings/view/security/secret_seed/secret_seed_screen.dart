import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SecretSeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WalletInfoProvider walletInfoProvider = Get.find();
    ToastManager toastManager = Get.find();
    var seed = walletInfoProvider.getWalletInfo()?.secretSeeds[0];
    return Scaffold(
      backgroundColor: context.colorTheme.background,
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        iconTheme: IconThemeData(color: context.colorTheme.accent),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'secret_seed'.tr,
            style: TextStyle(
                color: context.colorTheme.primaryText, fontSize: 17.0),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
          Text(
            'secret_seed_description'.tr,
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
                '$seed',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: context.colorTheme.primary,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700),
              ),
              trailing: Icon(CustomIcons.copy),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: seed));
                toastManager.showShortToast('data_copied'.tr);
              },
            ),
          )
        ]),
      ),
    );
  }
}
