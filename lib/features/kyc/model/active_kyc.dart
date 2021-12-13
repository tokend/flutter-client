import 'package:flutter_template/features/kyc/model/kyc_form.dart';

class ActiveKyc {}

class KycMissing extends ActiveKyc {}

class ActiveKycForm extends ActiveKyc {
  KycForm formData;

  ActiveKycForm(this.formData);
}
