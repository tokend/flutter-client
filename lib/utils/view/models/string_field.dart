import 'package:formz/formz.dart';

enum StringFieldError { empty, invalid }

class StringField extends FormzInput<String, StringFieldError> {
  const StringField.pure([String value = '']) : super.pure(value);

  const StringField.dirty([String value = '']) : super.dirty(value);

  @override
  StringFieldError? validator(String value) {
    if (value?.isNotEmpty == false) {
      return StringFieldError.empty;
    } else {
      return null;
    }
  }
}
