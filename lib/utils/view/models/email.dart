import 'package:formz/formz.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum EmailValidationError { empty, invalid, alreadyTaken }

class Email extends FormzInput<String, EmailValidationError> {
  Email.pure() : super.pure('');

  Email.dirty({String value = '', this.serverError}) : super.dirty(value);

  Exception? serverError;

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (serverError != null) {
      return EmailValidationError.alreadyTaken;
    }
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

extension Explanation on EmailValidationError {
  String? get name {
    switch (this) {
      case EmailValidationError.alreadyTaken:
        return 'error_already_taken_email'.tr;
      case EmailValidationError.invalid:
        return 'error_invalid_email'.tr;
      default:
        return null;
    }
  }
}
