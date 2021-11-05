import 'package:flutter/cupertino.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/settings/view/account_type_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AccountTypeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colourScheme = context.colorTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.0, bottom: 14.0),
            child: Text(
              'account_type'.tr,
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: colourScheme.accent),
            ),
          ),
          AccountTypeItem('general'.tr, 'general_description'.tr),
          Padding(padding: EdgeInsets.only(top: 16.0)),
          AccountTypeItem('corporate'.tr, 'corporate_description'.tr),
        ],
      ),
    );
  }
}
