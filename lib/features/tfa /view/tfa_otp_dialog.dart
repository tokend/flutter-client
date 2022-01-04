import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_dialog_factory.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// Abstract TFA verification dialog for plain one-time password.
abstract class TfaOtpDialog extends TfaDialogView {
  TfaVerifierInterface tfaVerifierInterface;

  TfaOtpDialog(this.tfaVerifierInterface) : super(tfaVerifierInterface);

  @override
  String getInvalidInputError() {
    return 'invalid_code'.tr;
  }
}
