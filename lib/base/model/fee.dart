import 'package:decimal/decimal.dart';

class Fee {
  Decimal calculatedPercent;
  Decimal fixed;

  Fee.fromJson(Map<String, dynamic> json)
      : calculatedPercent = Decimal.parse(json['calculated_percent']),
        fixed = Decimal.parse(json['fixed']);
}
