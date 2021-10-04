import 'package:formz/formz.dart';

enum NameError { empty, invalid }

class FirstName extends FormzInput<String, NameError> {
  const FirstName.pure([String value = '']) : super.pure(value);

  const FirstName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^(?=.*[a-z])[A-Za-z ]{2,}$',
  );

  @override
  NameError? validator(String value) {
    if (value?.isNotEmpty == false) {
      return NameError.empty;
    }
    return _nameRegExp.hasMatch(value) ? null : NameError.invalid;
  }
}

class LastName extends FormzInput<String, NameError> {
  const LastName.pure([String value = '']) : super.pure(value);

  const LastName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^(?=.*[a-z])[A-Za-z ]{2,}$',
  );

  @override
  NameError? validator(String value) {
    if (value?.isNotEmpty == false) {
      return NameError.empty;
    }
    return _nameRegExp.hasMatch(value) ? null : NameError.invalid;
  }
}

extension Explanation on NameError {
  String? get name {
    switch (this) {
      case NameError.empty:
        return 'Field must not be empty';
      case NameError.invalid:
        return 'Invalid name';
      default:
        return null;
    }
  }
}
