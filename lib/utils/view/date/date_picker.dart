import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> selectDate(BuildContext context,
    {int firstDate = 2015, int lastDate = 2050}) async {
  final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(firstDate),
      lastDate: DateTime(lastDate));
  if (pickedDate != null) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(pickedDate);
  } else {
    null;
  }
}
