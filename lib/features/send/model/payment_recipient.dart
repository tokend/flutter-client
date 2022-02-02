import 'package:dart_wallet/base32check.dart';
import 'package:dart_wallet/version_byte.dart';
import 'package:flutter_template/features/account/model/identity_resource_model.dart';
import 'package:flutter_template/features/account/storage/account_identities_repository.dart';

class PaymentRecipient {
  String accountId;
  String? nickname;

  PaymentRecipient(this.accountId, {this.nickname});
}

class AccountIdentityRecord {
  String login;
  String accountId;

  AccountIdentityRecord.fromIdentityResource(IdentityResourceModel identity)
      : login = identity.email,
        accountId = identity.address;
}

class PaymentRecipientLoader {
  AccountIdentitiesRepository _accountIdentitiesRepository;

  PaymentRecipientLoader(this._accountIdentitiesRepository);

  Future<PaymentRecipient> load(String recipient) {
    bool isAccountId =
        Base32Check.isValid(VersionByte(VersionByte.ACCOUNT_ID), recipient);

    if (isAccountId) {
      return Future.value(PaymentRecipient(recipient));
    }

    return _accountIdentitiesRepository
        .getAccountIdByLogin(recipient)
        .then((accountId) => PaymentRecipient(accountId, nickname: recipient));
  }
}
