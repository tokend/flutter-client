import 'package:flutter_template/features/assets/model/asset.dart';

class SimpleAsset implements Asset {
  @override
  String code;

  @override
  String? name;

  @override
  int trailingDigits;

  static const int DEFAULT_TRAILING_DIGITS = 6;

  SimpleAsset(this.code, this.name, this.trailingDigits);

  SimpleAsset.simpleModel(Map<String, dynamic> json)
      : code = json['id'],
        name = '',
        trailingDigits = DEFAULT_TRAILING_DIGITS;

  SimpleAsset.fromJson(Map<String, dynamic> json)
      : code = json['id'],
        name = json['data']['attributes']['name'],
        trailingDigits = json['data']['attributes']['trailing_digits'];
}
