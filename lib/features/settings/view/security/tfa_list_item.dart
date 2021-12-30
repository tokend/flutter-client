import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TfaListItem extends StatefulWidget {
  @override
  State<TfaListItem> createState() => _TfaListItemState();
}

class _TfaListItemState extends State<TfaListItem> {
  bool isSwitchOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    var tfaState = await getSwitchState();
    if (tfaState != null) {
      isSwitchOn = tfaState;
    }
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    print(isSwitchedFT);

    return isSwitchedFT;
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = context.colorTheme;

    return Container(
      color: colorTheme.primaryLight,
      child: SwitchListTile(
          activeColor: colorTheme.primary,
          title: Text(
            'tfa_label'.tr,
            style: TextStyle(
                color: colorTheme.primary,
                fontSize: 13.0,
                fontWeight: FontWeight.w700),
          ),
          secondary: Icon(
            CustomIcons.key,
            color: colorTheme.primary,
          ),
          value: isSwitchOn,
          onChanged: (bool value) {
            setState(() {
              isSwitchOn = value;
              saveSwitchState(value);
            });
          }),
    );
  }
}
