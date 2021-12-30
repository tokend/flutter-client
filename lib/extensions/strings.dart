import 'package:sprintf/sprintf.dart';

extension LongStrings on String {
  void printLongString() {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(this)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }
}

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}
