import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/pagination/paging_record.dart';

class MemoryOnlyPagedDataCache<T> implements PagedDataCache<T> {
  List<T> _items = [];

  @override
  cachePage(DataPage<dynamic> page) {
    _items.addAll(page.items as List<T>);
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
  Future<DataPage<T>> getPage(int limit, int? cursor, PagingOrder order) {
    int? actualCursor = cursor;
    if (actualCursor == null) {
      if (order == PagingOrder.DESC) {
        actualCursor = 0; // TODO add int getting int max value
      }
    }
    var pageItems = _items;
    if (order == PagingOrder.DESC) {
      pageItems.sort((b, a) => (a as PagingRecord)
          .getPagingId()
          .compareTo((b as PagingRecord).getPagingId()));
    } else {
      pageItems.sort((a, b) => (a as PagingRecord)
          .getPagingId()
          .compareTo((b as PagingRecord).getPagingId()));
    }

    if (order == PagingOrder.DESC) {
      pageItems.where(
          (element) => (element as PagingRecord).getPagingId() < actualCursor!);
    } else {
      pageItems.where(
          (element) => (element as PagingRecord).getPagingId() > actualCursor!);
    }

    var nextCursor = cursor?.toString();
    if (pageItems.isNotEmpty) {
      nextCursor = (pageItems.last as PagingRecord).getPagingId().toString();
    }
    return Future.value(
        DataPage(nextCursor, pageItems, pageItems.length < limit));
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
