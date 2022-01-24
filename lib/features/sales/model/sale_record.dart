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

  SaleRecord.fromJson(
    Map<String, dynamic> data,
    Map<String, dynamic> included,
  )   : name = data['attributes']['details']['name'],
        description = data['attributes']['details']['short_description'],
        ownerId = data['relationships']['owner']['data']['id'],
        baseHardCap = Decimal.parse(data['attributes']['base_hard_cap']),
        startTime = DateTime.parse(data['attributes']['start_time']),
        endTime = DateTime.parse(data['attributes']['end_time']),
        accessDefinitionType =
            NameValue.fromJson(data['attributes']['access_definition_type']),
        saleState = NameValue.fromJson(data['attributes']['sale_state']),
        saleType = NameValue.fromJson(data['attributes']['sale_type']),
        baseAsset = SimpleAsset.simpleModel(
            data['relationships']['base_asset']['data']),
        defaultQuoteAsset = SaleQuoteAsset(included),
        quoteAssets = [
          SaleQuoteAsset(included),
        ];
}

class NameValue {
  String name;
  int value;

  NameValue(this.name, this.value);

  NameValue.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];
}

class SaleQuoteAsset implements Asset {
  @override
  String code;
  @override
  String? name;
  @override
  int trailingDigits = 6;

  Decimal price;
  Decimal totalCurrentCap;
  Decimal hardCap;
  Decimal currentCap;
  Decimal softCap;

  SaleQuoteAsset(
    Map<String, dynamic> json,
  )   : code = json['relationships']['asset']['data']['id'],
        price = Decimal.parse(json['attributes']['price']),
        totalCurrentCap =
            Decimal.parse(json['attributes']['total_current_cap']),
        currentCap = Decimal.parse(json['attributes']['current_cap']),
        hardCap = Decimal.parse(json['attributes']['hard_cap']),
        softCap = Decimal.parse(json['attributes']['soft_cap']);
}
