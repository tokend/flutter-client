import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/record_with_policy.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class AssetPairRecord implements RecordWithPolicy {
  Asset base;
  Asset quote;
  Decimal price;
  String? logoUrl;

  @override
  int policy;

  late String id;

  AssetPairRecord(
      this.base, this.quote, this.price, this.logoUrl, this.policy) {
    id = '$base:$quote';
  }

  bool get isTradeable => hasPolicy(AssetPairPolicy.TRADEABLE_SECONDARY_MARKET);

  AssetPairRecord.fromJson(Map<String, dynamic> json, UrlConfig urlConfig)
      : base = SimpleAsset(json['relationships']['base_asset']['data']['id'],
            json['relationships']['base_asset']['data']['id'], 6),
        quote = SimpleAsset(json['relationships']['quote_asset']['data']['id'],
            json['relationships']['quote_asset']['data']['id'], 6),
        price = Decimal.parse(json['attributes']['price']),
        policy = json['attributes']['policies']['value'],
        logoUrl = '';

  /*AssetRecord.fromJson(
                json['relationships']['base_asset']['data'], urlConfig)
            .logoUrl*/ //TODO

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AssetPairRecord && other.id == this.id;
  }
}
