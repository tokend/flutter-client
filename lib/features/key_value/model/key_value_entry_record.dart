import 'package:dart_wallet/xdr/xdr_types.dart';

class KeyValueEntryRecord {
  final String key;
  final String value;

  KeyValueEntryRecord(this.key, this.value);

  static KeyValueEntryRecord fromJson(Map<String, dynamic> source) {
    var key = source["id"];
    var value = source["value"];

    KeyValueEntryRecord keyValueRecord;
    switch (value) {
      case KeyValueEntryType.STRING:
        keyValueRecord = StringOwn(key, value["str"]);
        break;
      case KeyValueEntryType.UINT64:
        keyValueRecord = NumberOwn(key, value["u64"]);
        break;
      case KeyValueEntryType.UINT32:
        keyValueRecord = NumberOwn(key, value["u32"]);
        break;
      default:
        throw Exception("Unknown KeyValue type " +
            "${value.type.name} ${value.type.value}");
    }
    return keyValueRecord;
  }
}

class StringOwn extends KeyValueEntryRecord {
  final String key;
  final String value;

  StringOwn(this.key, this.value) : super(key, value);
}

class NumberOwn extends KeyValueEntryRecord {
  final String key;
  final int valueInt;

  NumberOwn(this.key, this.valueInt)
      : super(key,
            valueInt.toString()); //todo: maybe need to change type of value
}
