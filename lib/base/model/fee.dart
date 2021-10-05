import 'package:decimal/decimal.dart';

class Fee {
  Decimal calculatedPercent;
  Decimal fixed;

  Fee.fromJson(Map<String, dynamic> json)
      : calculatedPercent = json['calculated_percent'],
        fixed = json['fixed'];
}
