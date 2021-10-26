import 'package:dart_sdk/api/base/model/remote_file.dart';

abstract class KycForm {
  String getRoleKey();

  static const _ROLE_KEY_PREFIX = "account_role";
}

class GeneralKycForm extends KycForm {
  static final ROLE_KEY = "${KycForm._ROLE_KEY_PREFIX}:general";

  String firstName;
  String lastName;
  RemoteFile avatar;

  GeneralKycForm(
      {required this.firstName, required this.lastName, required this.avatar});

  GeneralKycForm.fromJson(Map<String, dynamic> json)
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

  Map<String, dynamic> toJson() => {
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
