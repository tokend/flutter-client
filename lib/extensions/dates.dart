import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}

const String FULL_DATE_AND_TIME = 'MMM dd, yyyy hh:mm';
