import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:flutter_template/data/storage%20/repository/multiple_items_repository.dart';
import 'package:flutter_template/features/key_value/model/key_value_entry_record.dart';

class KeyValueEntriesRepository
    extends MultipleItemsRepository<KeyValueEntryRecord> {
  final TokenDApi api;

  KeyValueEntriesRepository(this.api);

  Map<String, KeyValueEntryRecord> entriesMap = {};

  @override
  Future<List<KeyValueEntryRecord>> getItems() {
    return api.v3.keyValue
        .get(params: Builder().withLimit(50).withOrder(PagingOrder.ASC).build())
        .then((list) {
      List<KeyValueEntryRecord> resultList = [];
      list.forEach((v) {
        resultList.add(KeyValueEntryRecord.fromJson(v));
      });
      return resultList;
    });
  }

  Future<KeyValueEntryRecord> getItem(String key) {
    return api.v3.keyValue
        .getById(key)
        .then((json) => KeyValueEntryRecord.fromJson(json))
        .then((entryRecord) => entriesMap[key] = entryRecord);
  }
}
