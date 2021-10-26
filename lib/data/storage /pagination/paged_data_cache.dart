import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter_template/data/storage%20/model/paging_order.dart';

/// Cache of [PagingRecord] ordered by [PagingRecord.getPagingId].
/// You can't add new records to it unless their ID's are known,
/// otherwise it will break pagination.
abstract class PagedDataCache<T> {
  Future<DataPage<T>> getPage(int limit, int? cursor, PagingOrder order);

  cachePage(DataPage<T> page);

  update(List<T> items);

  delete(List<T> items);

  clear();
}
