import 'dart:convert';

import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:flutter_template/features/key_value/model/key_value_entry_record.dart';

/// KYC form data with documents
abstract class KycForm {
  String getRoleKey();

  static const _ROLE_KEY_PREFIX = "account_role";

  static KycForm fromBlob(
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
  late Map<String, RemoteFile>? documents;

  GeneralKycForm(
      {required this.firstName, required this.lastName, this.documents});

  GeneralKycForm.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'] {
    documents = getRemoteFiles(json['documents']);
  }

  Map<String, dynamic> toJson() =>
      {'first_name': firstName, 'last_name': lastName, 'documents': documents};

  @override
  String getRoleKey() {
    return ROLE_KEY;
  }

  Map<String, RemoteFile>? getRemoteFiles(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, RemoteFile.fromJson(value)));
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

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar.toJson()
      };

  @override
  String getRoleKey() {
    return ROLE_KEY;
  }

  @override
  bool operator ==(Object other) {
    if (other is GeneralKycForm == false) return false;

    other as GeneralKycForm;

    if (firstName != other.firstName) return false;
    if (lastName != other.lastName) return false;

    return true;
  }

  @override
  int get hashCode => 31 * firstName.hashCode + lastName.hashCode;
}

class EmptyKycForm extends KycForm {
  @override
  String getRoleKey() {
    throw Exception("You can't use empty form to change role");
  }
}
