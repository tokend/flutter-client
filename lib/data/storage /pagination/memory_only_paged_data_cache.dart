import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter_template/data/storage%20/model/paging_order.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/pagination/paging_record.dart';

class MemoryOnlyPagedDataCache<T> implements PagedDataCache {
  var _items = List<T>.empty();

  @override
  cachePage(DataPage<dynamic> page) {
    _items.addAll(page.items as Iterable<T>);
  }

  @override
  clear() {
    _items.clear();
  }

  @override
  delete(List<dynamic> items) {
    items.forEach((element) {
      _items.remove(element);
    });
  }

  @override
  Future<DataPage> getPage(int limit, int? cursor, PagingOrder order) {
    int? actualCursor = cursor;
    if (actualCursor == null) {
      if (order == PagingOrder.desc) {
        actualCursor = 0; // TODO add int getting int max value
      }
    }
    var pageItems = _items;
    if (order == PagingOrder.desc) {
      pageItems.sort((b, a) => (a as PagingRecord)
          .getPagingId()
          .compareTo((b as PagingRecord).getPagingId()));
    } else {
      pageItems.sort((a, b) => (a as PagingRecord)
          .getPagingId()
          .compareTo((b as PagingRecord).getPagingId()));
    }

    if (order == PagingOrder.desc) {
      pageItems.where(
          (element) => (element as PagingRecord).getPagingId() < actualCursor!);
    } else {
      pageItems.where(
          (element) => (element as PagingRecord).getPagingId() > actualCursor!);
    }

    return Future.value(DataPage(
        (pageItems.last as PagingRecord).getPagingId().toString(),
        pageItems,
        pageItems.length < limit));
  }

  @override
  update(List items) {
    for (int i = 0; i < _items.length; i++) {
      var updateIndex = _items.indexOf(_items[i]);
      if (updateIndex >= 0) {
        _items[i] = items[updateIndex];
      }
    }
  }
}
