import 'package:flutter_template/utils/validators/regex_validator.dart';

class PasswordValidator extends RegexValidator {
  static final _instance = PasswordValidator._internal();

  PasswordValidator._internal() : super("^.{6,}\$");

  factory PasswordValidator.get() {
    return _instance;
  }
}
