import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/record_with_policy.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/features/assets/model/asset.dart';

class AssetRecord implements Asset, RecordWithPolicy {
  @override
  String code;

  @override
  String? name;

  @override
  int trailingDigits = 6;

  String? logoUrl;

  String ownerAccountId;

  @override
  late int policy;

  int? externalSystemType;

  bool isConnectedToCoinpayments = false;

  late Decimal issued;
  late Decimal available;
  late Decimal maximum;

  AssetRecord(
    this.code,
    this.name,
    this.trailingDigits,
    this.logoUrl,
    this.ownerAccountId,
    this.policy,
    this.externalSystemType,
    this.isConnectedToCoinpayments,
    this.issued,
    this.available,
    this.maximum,
  );

  AssetRecord.fromJson(Map<String, dynamic> json, UrlConfig urlConfig)
      : code = json['id'],
        name = json['attributes']['details']['name'],
        ownerAccountId = json['relationships']['owner']['data']['id'] {
    logoUrl = getLogoUrl(json['attributes']?['details']?['logo'], urlConfig);
    policy = json['attributes']['policies']['value'];
    if (json['attributes']['details']['external_system_type'] != null) {
      externalSystemType = int.parse(
          json['attributes']['details']['external_system_type'].toString());
    }

    if (json['attributes']['details']['is_coinpayments'] != null) {
      isConnectedToCoinpayments = true;
    }

    issued = Decimal.parse(json['attributes']['issued']);
    available = Decimal.parse(json['attributes']['available_for_issuance']);
    maximum = Decimal.parse(json['attributes']['max_issuance_amount']);
  }

  AssetRecord.single(Map<String, dynamic> json, UrlConfig urlConfig)
      : code = json['code'],
        ownerAccountId = json['owner'] {
    logoUrl = getLogoUrl(json['details']?['logo'], urlConfig);
    policy = json['policy'];
    if (json['details']['external_system_type'] != null) {
      externalSystemType =
          int.parse(json['details']['external_system_type'].toString());
    }

    if (json['details']['is_coinpayments'] != null) {
      isConnectedToCoinpayments = true;
    }

    issued = Decimal.parse(json['issued']);
    available = Decimal.parse(json['available_for_issuance']);
    maximum = Decimal.parse(json['max_issuance_amount']);
  }

  String? getLogoUrl(Map<String, dynamic>? json, UrlConfig urlConfig) {
    if (json != null) {
      RemoteFile logo = RemoteFile.fromJson(json);

      return logo.getUrl(urlConfig.storage);
    }
  }

  bool get isBackedByExternalSystem => externalSystemType != null;

  bool get isTransferable => hasPolicy(AssetPolicy.TRANSFERABLE);

  bool get isWithdrawable => hasPolicy(AssetPolicy.WITHDRAWABLE);

  bool get canBeBaseInAtomicSwap =>
      hasPolicy(AssetPolicy.CAN_BE_BASE_IN_ATOMIC_SWAP);

  bool get canBeQuoteInAtomicSwap =>
      hasPolicy(AssetPolicy.CAN_BE_QUOTE_IN_ATOMIC_SWAP);

  bool get isDepositable =>
      isBackedByExternalSystem || isConnectedToCoinpayments;

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AssetRecord &&
        policy == other.policy &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        externalSystemType == other.externalSystemType &&
        ownerAccountId == other.ownerAccountId &&
        isConnectedToCoinpayments == other.isConnectedToCoinpayments &&
        available == other.available &&
        issued == other.issued &&
        maximum == other.maximum;
  }
}
