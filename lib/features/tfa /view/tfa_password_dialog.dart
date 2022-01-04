import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/password_tfa_otp_generator.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter_template/features/biometrics/biometric_auth_manager.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_dialog_factory.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// TFA verification dialog requesting user's password and
/// forming OTP from it.
class TfaPasswordDialog extends TfaDialogView {
  TfaVerifierInterface tfaVerifierInterface;
  NeedTfaException _tfaException;
  String _login;

  late BiometricAuthManager _biometricAuthManager;

  TfaPasswordDialog(this.tfaVerifierInterface, this._tfaException, this._login)
      : super(tfaVerifierInterface) {
    _biometricAuthManager = BiometricAuthManager(onAuthEnabled: () {
      verify();
    }, onAuthDisabled: () {
      toastManager.showShortToast('Error occurred');
    });
    //_requestAuthIfPossible();
  }

  _requestAuthIfPossible() {
    _biometricAuthManager.requestAuthIfPossible();
  }

  @override
  Future<String> getOtp(String input) {
    return PasswordTfaOtpGenerator().generate(_tfaException, _login, input);
  }

  @override
  String getInvalidInputError() {
    return 'invalid_password'.tr;
  }

  @override
  String getMessage() {
    return 'enter_your_password'.tr;
  }
}
