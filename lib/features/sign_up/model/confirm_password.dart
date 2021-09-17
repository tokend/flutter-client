import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError {
  invalid,
  mismatch,
}

class ConfirmPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      print("CONF -> $value");
      return ConfirmedPasswordValidationError.invalid;
    }
    print(
        "CONF_VALIDATION -> value -> $value -> ${password == value ? null : ConfirmedPasswordValidationError.mismatch}");
    return password == value ? null : ConfirmedPasswordValidationError.mismatch;
  }
}

extension Explanation on ConfirmedPasswordValidationError {
  String? get name {
    switch (this) {
      case ConfirmedPasswordValidationError.mismatch:
        print("Passwords must match");
        return 'Passwords must match';
      default:
        print(this);
        return null;
    }
  }
}
