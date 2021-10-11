import 'package:dart_sdk/api/base/model/remote_file.dart';

class KycForm {
  String firstName;
  String lastName;
  RemoteFile avatar;

  KycForm(
      {required this.firstName, required this.lastName, required this.avatar});

  KycForm.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar.toJson()
      };
}
