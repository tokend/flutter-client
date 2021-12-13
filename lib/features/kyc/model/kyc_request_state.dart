import 'package:flutter_template/features/kyc/model/kyc_form.dart';

class KycRequestState {
  KycRequestState._();

  factory KycRequestState.submitted(
      KycForm formData, int requestId, int roleToSet) = Submitted._;
}

class Submitted<FormType extends KycForm> extends KycRequestState {
  Submitted._(this.formData, this.requestId, this.roleToSet) : super._();
  final FormType formData;
  final int requestId;
  final int roleToSet;

// factory Submitted.pending(FormType formData, int requestId, int roleToSet) = Pending;
// factory Submitted.rejected(FormType formData, int requestId, int roleToSet) = Rejected;
// factory Submitted.aproved(FormType formData, int requestId, int roleToSet) = Approved;
}

class Pending<FormType extends KycForm> extends Submitted {
  Pending(FormType formData, int requestId, int roleToSet)
      : super._(formData, requestId, roleToSet);
}

class Rejected<FormType extends KycForm> extends Submitted {
  Rejected(FormType formData, int requestId, int roleToSet)
      : super._(formData, requestId, roleToSet);
}

class Approved<FormType extends KycForm> extends Submitted {
  Approved(FormType formData, int requestId, int roleToSet)
      : super._(formData, requestId, roleToSet);
}

class Empty extends KycRequestState {
  Empty() : super._();
}
