import 'dart:developer';

class AccountRecord {
  String id;
  int roleId;
  KycRecoveryStatus kycRecoveryStatus;
  String? kycBlob;

  AccountRecord(this.id, this.roleId, this.kycRecoveryStatus, this.kycBlob);

  AccountRecord.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'],
        roleId = int.parse(json['data']['relationships']['role']['data']['id']),
        kycRecoveryStatus = getKycRecoveryStatus(
            json['data']['attributes']['kyc_recovery_status']['name']),
        kycBlob = (json['included'] as List).isNotEmpty
            ? json['included'][0]['attributes']['kyc_data']['blob_id']
            : null;

  Map<String, dynamic> toJson() => {
        //TODO fix up wrong structure
        'id': id,
        'role_id': roleId,
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
