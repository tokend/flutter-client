import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_otp_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TfaEmailOtpDialog extends TfaOtpDialog {
  TfaVerifierInterface tfaVerifierInterface;

  TfaEmailOtpDialog(this.tfaVerifierInterface) : super(tfaVerifierInterface);

  @override
  String getMessage() {
    return 'enter_temporary_code_from_email'.tr;
  }
}
