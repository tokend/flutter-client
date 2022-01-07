import 'package:flutter_template/utils/validators/regex_validator.dart';

class EmailValidator extends RegexValidator {
  static final _instance = EmailValidator._internal();

  EmailValidator._internal()
      : super(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  factory EmailValidator.get() {
    return _instance;
  }
}
