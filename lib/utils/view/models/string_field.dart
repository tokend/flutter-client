import 'package:formz/formz.dart';

enum StringFieldError { empty, invalid }

class StringField extends FormzInput<String, StringFieldError> {
  final bool isOptional;

  const StringField.pure({String value = '', this.isOptional = false})
      : super.pure(value);

  const StringField.dirty({String value = '', this.isOptional = false})
      : super.dirty(value);

  @override
  StringFieldError? validator(String value) {
    if (value.isNotEmpty == false && !isOptional) {
      return StringFieldError.empty;
    } else {
      return null;
    }
  }
}

extension Explanation on StringFieldError {
  String? get name {
    switch (this) {
      /*case StringFieldError.empty:
        return 'Field must not be empty';*/
      default:
        return null;
    }
  }
}
