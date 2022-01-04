import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthManager extends BaseWidget {
  Function? onAuthEnabled;
  Function? onAuthDisabled;

  BiometricAuthManager({
    this.onAuthEnabled,
    this.onAuthDisabled,
  });

  static const String PREFERENCE_KEY = "fingerprint";
  static const bool IS_ENABLED_BY_DEFAULT = true;

  bool get isAuthEnabled =>
      sharedPreferences.getBool(PREFERENCE_KEY) ?? IS_ENABLED_BY_DEFAULT;

  set isAuthEnabled(bool value) =>
      sharedPreferences.setBool(PREFERENCE_KEY, value);

  Future<bool> get hasBiometrics async =>
      await localAuthentication.canCheckBiometrics;

  void requestAuthIfPossible() async {
    var msg = '';
    try {
      if (await hasBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuthentication.getAvailableBiometrics();
        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            bool pass = await localAuthentication.authenticate(
                localizedReason: 'finger_print_hint'.tr, biometricOnly: true);

            if (pass) {
              log('if(pass)==true');
              onAuthEnabled?.call();
            }
          }
        } else {
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            log('availableBiometrics.contains(BiometricType.fingerprint)');
            bool pass = await localAuthentication.authenticate(
                localizedReason: 'finger_print_hint'.tr, biometricOnly: true);

            if (pass) {
              onAuthEnabled?.call();
            }
          } else {
            log('Android BiometricType.fingerprint not allowed');
            onAuthDisabled?.call();
          }
        }
      } else {
        msg = "You are not allowed to access biometrics.";
        onAuthDisabled?.call();
      }
    } on PlatformException catch (e) {
      msg = "Error while opening fingerprint/face scanner";
      log(e.stacktrace.toString() + ' ${e.code}');
      onAuthDisabled?.call();
    }

    log('message $msg');
  }
}
