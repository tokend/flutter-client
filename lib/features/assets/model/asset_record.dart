import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/features/assets/model/asset.dart';

class AssetRecord implements Asset {
  @override
  String code;

  @override
  String? name;

  @override
  int trailingDigits = 6;

  String? logoUrl;

  String ownerAccountId;

  AssetRecord(this.code, this.name, this.trailingDigits, this.logoUrl,
      this.ownerAccountId);

  AssetRecord.fromJson(Map<String, dynamic> json, UrlConfig urlConfig)
      : code = json['id'],
        name = json['attributes']['details']['name'],
        ownerAccountId = json['relationships']['owner']['data']['id'] {
    logoUrl = '';
    //getLogoUrl(json['attributes']['details']['logo'], urlConfig); //TODO
  }

  String? getLogoUrl(Map<String, dynamic> json, UrlConfig urlConfig) {
    RemoteFile logo = RemoteFile.fromJson(json);

    return logo.getUrl(urlConfig.storage);
  }
}
