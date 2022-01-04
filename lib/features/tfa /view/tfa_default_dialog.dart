import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_otp_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TfaDefaultDialog extends TfaOtpDialog {
  TfaVerifierInterface tfaVerifierInterface;

  TfaDefaultDialog(this.tfaVerifierInterface) : super(tfaVerifierInterface);

  @override
  String getMessage() {
    return 'enter_code'.tr;
  }
}
