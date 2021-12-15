import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/fee.dart' as FeeResource;

class SimpleFeeRecord {
  Decimal fixed;
  Decimal percent;

  late Decimal total;

  SimpleFeeRecord(this.fixed, this.percent) {
    total = fixed + percent;
  }

  SimpleFeeRecord.fromFee(FeeResource.Fee fee)
      : fixed = fee.fixed,
        percent = fee.calculatedPercent {
    total = fixed + percent;
  }

  SimpleFeeRecord.fromJson(Map<String, dynamic> json)
      : fixed = json['fixed'],
        percent = json['calculated_percent'] {
    total = fixed + percent;
  }

  static var zero = SimpleFeeRecord(Decimal.zero, Decimal.zero);

  Fee toXdrFee(NetworkParams networkParams) {
    return Fee(
        Int64(networkParams.amountToPrecised(fixed.toDouble())),
        Int64(networkParams.amountToPrecised(percent.toDouble())),
        FeeExtEmptyVersion());
  }
}
