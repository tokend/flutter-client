
import 'package:flutter_template/features/account/model/account_role.dart';
import 'package:flutter_template/features/key_value/model/key_value_entry_record.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ResolvedAccountRole {
  int id;
  late String accountRole;

  ResolvedAccountRole(this.id, this.accountRole);

  ResolvedAccountRole.fromKeyEntries(
      this.id, List<KeyValueEntryRecord> keyValueEntries) {
    var keyValueEntry = keyValueEntries.firstWhereOrNull(
        (element) => element is NumberOwn && element.valueInt == id);

    if (keyValueEntry != null) {
      accountRole = AccountRole.valueForKey(keyValueEntry.key);
    } else {
      accountRole = AccountRole.UNKNOWN;
    }
  }
}
