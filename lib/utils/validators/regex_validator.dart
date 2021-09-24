abstract class RegexValidator {
  final RegExp _regex;

  RegexValidator(String pattern) : this._regex = RegExp(pattern);

  bool isValid(String? str) {
    return str != null && _regex.hasMatch(str);
  }
}
