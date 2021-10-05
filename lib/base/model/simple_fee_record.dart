import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';

class SimpleFeeRecord {
  Decimal fixed;
  Decimal percent;

  SimpleFeeRecord(this.fixed, this.percent);

  static var zero = SimpleFeeRecord(Decimal.zero, Decimal.zero);

  Fee toXdrFee(NetworkParams networkParams) {
    return Fee(
        Int64(networkParams.amountToPrecised(fixed.toDouble())),
        Int64(networkParams.amountToPrecised(percent.toDouble())),
        FeeExtEmptyVersion());
  }
}
