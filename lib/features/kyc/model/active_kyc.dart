import 'package:flutter_template/features/kyc/model/kyc_form.dart';

class ActiveKyc {}

class KycMissing extends ActiveKyc {}

class Form extends ActiveKyc {
  KycForm formData;

  Form(this.formData);
}
