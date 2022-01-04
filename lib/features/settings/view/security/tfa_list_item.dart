import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/tfa%20/logic/disable_tfa_use_case.dart';
import 'package:flutter_template/features/tfa%20/logic/enable_tfa_use_case.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TfaListItem extends BaseStatefulWidget {
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
    prefs.setBool("tfaState", value);
    print('Switch Value saved $value');
    return prefs.setBool("tfaState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("tfaState");
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
              if (isSwitchOn)
                _addAndEnableNewTfaFactor();
              else
                _disableTfa();
              saveSwitchState(value);
            });
          }),
    );
  }

  _disableTfa() async {
    await DisableTfaUseCase(
            TfaFactorType.TOTP, widget.repositoryProvider.tfaFactorsRepository)
        .perform();
  }

  _addAndEnableNewTfaFactor() async {
    await EnableTfaUseCase(
            TfaFactorType.TOTP, widget.repositoryProvider.tfaFactorsRepository)
        .perform();
  }
}
