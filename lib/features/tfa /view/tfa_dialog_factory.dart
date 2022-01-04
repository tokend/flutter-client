import 'dart:developer';

import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_default_dialog.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_email_otp_dialog.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_password_dialog.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_totp_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TfaDialogFactory {
  /// Return verification dialog for specified exception.
  /// If there is no special dialog for given TFA factor type
  /// then [TfaDefaultDialog] will be returned
  TfaDialogView getForException(
      NeedTfaException tfaException, TfaVerifierInterface verifierInterface,
      {String? login}) {
    TfaDialogView result = TfaDefaultDialog(verifierInterface);
    switch (tfaException.factorType) {
      case TfaFactorType.PASSWORD:
        if (login != null) {
          result = TfaPasswordDialog(verifierInterface, tfaException, login);
        }
        break;
      case TfaFactorType.EMAIL:
        result = TfaEmailOtpDialog(verifierInterface);
        break;
      case TfaFactorType.TOTP:
        result = TfaTotpDialog(verifierInterface);
        break;
      default:
        result = TfaDefaultDialog(verifierInterface);
    }

    return result;
  }
}

abstract class TfaDialogView extends BaseStatelessWidget {
  TfaVerifierInterface _tfaVerifierInterface;

  TfaDialogView(this._tfaVerifierInterface);

  var currentInputValue = '';
  late BuildContext currentContext;

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return AlertDialog(
      title: Text('tfa_label'.tr),
      content: TextField(
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(hintText: getMessage().tr),
        onChanged: (newValue) => currentInputValue = newValue,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () async {
            verify();
          },
          child: Text('ok'.tr),
        ),
      ],
    );
  }

  verify() async {
    var otp = await getOtp(currentInputValue);

    log('OTP: $otp');
    _tfaVerifierInterface.verify(otp,
        onError: (error) => onVerificationError(error));
  }

  onVerificationError(Exception? error) {
    if (error is InvalidOtpException) {
    } else if (error != null) {
      errorHandler.handle(error);
    }
  }

  show() {
    Get.dialog(this);
  }

  Future<String> getOtp(String input) async {
    return input;
  }

  String getMessage();

  String getInvalidInputError();
}
