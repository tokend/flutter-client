import 'package:decimal/decimal.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';

class SaleRecord {
  String name;
  String description;
  Decimal baseHardCap;
  DateTime startTime;
  DateTime endTime;
  NameValue accessDefinitionType;
  NameValue saleState;
  NameValue saleType;
  Asset baseAsset;
  Asset defaultQuoteAsset;
  List quoteAssets;
  String ownerId;

  SaleRecord(
    this.name,
    this.description,
    this.baseHardCap,
    this.startTime,
    this.endTime,
    this.accessDefinitionType,
    this.saleState,
    this.saleType,
    this.baseAsset,
    this.defaultQuoteAsset,
    this.quoteAssets,
    this.ownerId,
  );

  SaleRecord.fromJson(Map<String, dynamic> json)
      : name = json['attributes']['details']['name'],
        description = json['attributes']['details']['short_description'],
        ownerId = json['relationships']['owner']['data']['id'],
        baseHardCap = Decimal.parse(json['attributes']['base_hard_cap']),
        startTime = DateTime.parse(json['attributes']['start_time']),
        endTime = DateTime.parse(json['attributes']['end_time']),
        accessDefinitionType =
            NameValue.fromJson(json['attributes']['access_definition_type']),
        saleState = NameValue.fromJson(json['attributes']['sale_state']),
        saleType = NameValue.fromJson(json['attributes']['sale_type']),
        baseAsset = SimpleAsset.simpleModel(
            json['relationships']['base_asset']['data']),
        defaultQuoteAsset = SimpleAsset.simpleModel(
            json['relationships']['default_quote_asset']['data']),
        quoteAssets = json['relationships']['quote_assets']['data']
            .map((asset) => SimpleAsset.simpleModel(asset))
            .toList();
}

class NameValue {
  String name;
  int value;

  NameValue(this.name, this.value);

  NameValue.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];
}
