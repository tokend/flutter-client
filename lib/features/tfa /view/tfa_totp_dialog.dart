import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_otp_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// TFA verification dialog requesting code from the TOTP authenticator app.
class TfaTotpDialog extends TfaOtpDialog {
  TfaVerifierInterface tfaVerifierInterface;

  TfaTotpDialog(this.tfaVerifierInterface) : super(tfaVerifierInterface);

  @override
  String getInvalidInputError() {
    // TODO: implement getInvalidInputError
    throw UnimplementedError();
  }

  @override
  String getMessage() {
    return 'enter_temporary_code'.tr;
  }
}
