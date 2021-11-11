import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/features/settings/view/security/security_list_item.dart';
import 'package:flutter_template/features/settings/view/security/tfa_list_item.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SecurityTab extends BaseStatefulWidget {
  @override
  State<SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  var listItems = [
    SecurityListItem(
      'password_label'.tr,
      'password_description'.tr,
      CustomIcons.lock_1,
      onTap: () {
        Get.toNamed('/changePassword');
      },
    ),
    SecurityListItem(
      'account_id'.tr,
      'account_id_description'.tr,
      CustomIcons.user,
      onTap: () {
        Get.toNamed('/accountId');
      },
    ),
    SecurityListItem(
      'secret_seed'.tr,
      'secret_seed_description'.tr,
      CustomIcons.card_edit,
      onTap: () {
        Get.toNamed('/secretSeed');
      },
    ),
    SecurityListItem(
      'network_passphrase'.tr,
      'network_passphrase_description'.tr,
      CustomIcons.global_edit,
      onTap: () {
        Get.toNamed('/passphraseScreen');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listItems.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return TfaListItem();
            }
            return Builder(
                builder: (BuildContext context) => listItems[index - 1]);
          }),
    );
  }
}
