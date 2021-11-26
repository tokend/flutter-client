import 'dart:convert';

import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:flutter_template/features/key_value/model/key_value_entry_record.dart';

abstract class KycForm {
  String getRoleKey();

  static const _ROLE_KEY_PREFIX = "account_role";

  static KycForm? fromBlob(
      Blob blob, int roleId, List<KeyValueEntryRecord> keyValueEntries) {
    var roleKey;
    keyValueEntries.forEach((element) {
      if (element.key.startsWith(_ROLE_KEY_PREFIX) &&
          element is NumberOwn &&
          int.parse(element.value) == roleId) {
        roleKey = element.key;
      }
    });
    if (roleKey == GeneralKycForm.ROLE_KEY) {
      return GeneralKycForm.fromJson(jsonDecode(blob.attributes.value));
    } else if (roleKey == CorporateKycForm.ROLE_KEY) {
      return CorporateKycForm.fromJson(jsonDecode(blob.attributes.value));
    } else {
      throw Exception("Unknown KYC form type");
    }
  }
}

class GeneralKycForm extends KycForm {
  static final ROLE_KEY = "${KycForm._ROLE_KEY_PREFIX}:general";

  String firstName;
  String lastName;
  Map<String, RemoteFile>? document;

  GeneralKycForm(
      {required this.firstName, required this.lastName, this.document});

  GeneralKycForm.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        document = json['avatar'];

  Map<String, dynamic> toJson() =>
      {'first_name': firstName, 'last_name': lastName, 'documents': document};

  @override
  String getRoleKey() {
    // TODO: implement getRoleKey
    throw UnimplementedError();
  }
}

class CorporateKycForm extends KycForm {
  static final ROLE_KEY = "${KycForm._ROLE_KEY_PREFIX}:company";

  String firstName;
  String lastName;
  RemoteFile avatar;

  CorporateKycForm(
      {required this.firstName, required this.lastName, required this.avatar});

  CorporateKycForm.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() =>
      {
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar.toJson()
      };

  @override
  String getRoleKey() {
    // TODO: implement getRoleKey
    throw UnimplementedError();
  }
}

class EmptyKycForm extends KycForm {
  @override
  String getRoleKey() {
    throw Exception("You can't use empty form to change role");
  }
}
