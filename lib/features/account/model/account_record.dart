import 'dart:developer';

import 'package:flutter_template/features/account/model/resolved_account_role.dart';
import 'package:flutter_template/features/key_value/model/key_value_entry_record.dart';

class AccountRecord {
  String id;
  ResolvedAccountRole role;
  KycRecoveryStatus kycRecoveryStatus;
  String? kycBlob;

  AccountRecord(this.id, this.role, this.kycRecoveryStatus, this.kycBlob);

  AccountRecord.fromJson(
      Map<String, dynamic> json, List<KeyValueEntryRecord> keyValueEntries)
      : id = json['data']['id'],
        role = ResolvedAccountRole.fromKeyEntries(
            int.parse(json['data']['relationships']['role']['data']['id']),
            keyValueEntries),
        kycRecoveryStatus = getKycRecoveryStatus(
            json['data']['attributes']['kyc_recovery_status']['name']),
        kycBlob = (json['included'] as List).isNotEmpty
            ? json['included'][0]['attributes']['kyc_data']['blob_id']
            : null;

  Map<String, dynamic> toJson() => {
        //TODO fix up wrong structure
        'id': id,
        'role_id': role,
        'kyc_recovery_status': kycRecoveryStatus,
        'kyc_blob_id': kycBlob
      };
}

KycRecoveryStatus getKycRecoveryStatus(String status) {
  switch (status) {
    case 'none':
      return KycRecoveryStatus.NONE;
    case 'initiated':
      return KycRecoveryStatus.INITIATED;
    case 'pending':
      return KycRecoveryStatus.PENDING;
    case 'rejected':
      return KycRecoveryStatus.REJECTED;
    case 'permanently_rejected':
      return KycRecoveryStatus.PERMANENTLY_REJECTED;
    default:
      log('KycRecoveryStatus $status not found, was used the the default one');
      return KycRecoveryStatus.NONE;
  }
}

enum KycRecoveryStatus {
  NONE,
  INITIATED,
  PENDING,
  REJECTED,
  PERMANENTLY_REJECTED,
}
