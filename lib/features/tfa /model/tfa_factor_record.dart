import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';

class TfaFactorRecord {
  TfaFactorType type;
  int priority;
  int id;

  TfaFactorRecord(this.type, this.priority, {this.id = 0});

  TfaFactorRecord.fromRecord(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        priority = json['attributes']['priority'];
}
