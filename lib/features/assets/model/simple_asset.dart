import 'package:flutter_template/features/assets/model/asset.dart';

class SimpleAsset implements Asset {
  @override
  String code;

  @override
  String? name;

  @override
  int trailingDigits;

  SimpleAsset(this.code, this.name, this.trailingDigits);
}
