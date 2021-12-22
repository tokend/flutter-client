import 'package:dart_sdk/api/v3/params/fee_calculation_params.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/di/providers/api_provider.dart';

class FeeManager {
  ApiProvider _apiProvider;

  FeeManager(this._apiProvider);

  Future<SimpleFeeRecord> get(FeeType feeType, int subtype, String accountId,
      String asset, Decimal amount) {
    var signedApi = _apiProvider.getSignedApi();

    var params = FeeCalculationParams(
      asset,
      feeType,
      subtype,
      amount,
    );

    return signedApi.v3
        .getService()
        .get('v3/accounts/$accountId/calculated_fees', query: params.map())
        .then((response) =>
            SimpleFeeRecord.fromJson(response['data']['attributes']));
  }

  /// Return offer fee for given params
  Future<SimpleFeeRecord> getFee(
    int orderBookId,
    String accountId,
    String asset,
    Decimal amount,
  ) {
    var feeType;
    if (orderBookId != 0)
      feeType = FeeType.INVEST_FEE;
    else
      feeType = FeeType.OFFER_FEE;

    return get(FeeType(feeType), 0, accountId, asset, amount);
  }
}
