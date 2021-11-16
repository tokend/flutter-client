import 'package:formz/formz.dart';

enum PasswordValidationError { wrong, invalid, empty }

class Password extends FormzInput<String, PasswordValidationError> {
  Password.pure() : super.pure('');

  Password.dirty({String value = '', this.serverError})
      : super.dirty(value);

  static final _passwordRegExp = RegExp(r'^.{6,}$');

  Exception? serverError;

  @override
  PasswordValidationError? validator(String value) {
    if (serverError != null) {
      return PasswordValidationError.wrong;
    }
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}

extension Explanation on PasswordValidationError? {
  String? get name {
    switch (this) {
      case PasswordValidationError.invalid:
        return "Invalid condition";
      case PasswordValidationError.wrong:
        return "Your password is wrong, try again";
      default:
        return null;
    }
  }
}
