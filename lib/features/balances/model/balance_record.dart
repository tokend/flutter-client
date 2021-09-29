import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';

class BalanceRecord {
  String id;
  AssetRecord asset;
  double available;
  Asset? conversionAsset;
  int? convertedAmount;
  int? conversionPrice;

  BalanceRecord(this.id, this.asset, this.available);

  @override
  bool operator ==(Object other) {
    return other is BalanceRecord && other.id == this.id;
  }

  BalanceRecord.fromJson(Map<String, dynamic> json, UrlConfig urlConfig)
      : id = json['id'],
        asset = AssetRecord.fromJson(json['asset'], urlConfig),
        available = json['state']['available'];

  @override
  int get hashCode => id.hashCode;
}
