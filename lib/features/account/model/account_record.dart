class AccountRecord {
  String id;
  int roleId;
  KycRecoveryStatus kycRecoveryStatus;
  String? kycBlob;

  AccountRecord(this.id, this.roleId, this.kycRecoveryStatus, this.kycBlob);

  AccountRecord.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        roleId = json['role_id'],
        kycRecoveryStatus = json['kyc_recovery_status'],
        kycBlob = json['kyc_blob_id'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'role_id': roleId,
        'kyc_recovery_status': kycRecoveryStatus,
        'kyc_blob_id': kycBlob};

}

enum KycRecoveryStatus {
  NONE,
  INITIATED,
  PENDING,
  REJECTED,
  PERMANENTLY_REJECTED,
}