import 'package:decimal/decimal.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class FeeRecord {
  int feeType;
  int subtype;
  SimpleAsset asset;
  Decimal fixed;
  Decimal percent;
  Decimal lowerBound;
  Decimal upperBound;

  FeeRecord(this.feeType, this.subtype, this.asset, this.fixed, this.percent,
      this.lowerBound, this.upperBound);

  FeeRecord.fromJson(Map<String, dynamic> json, UrlConfig urlConfig)
      : feeType = json['attributes']['applied_to']['fee_type'],
        subtype = json['attributes']['applied_to']['subtype'],
        asset = SimpleAsset(json['attributes']['applied_to']['asset'], '', 6),
        fixed = Decimal.parse(json['attributes']['fixed']),
        percent = Decimal.parse(json['attributes']['percent']),
        lowerBound =
            Decimal.parse(json['attributes']['applied_to']['lower_bound']),
        upperBound =
            Decimal.parse(json['attributes']['applied_to']['upper_bound']);
}
