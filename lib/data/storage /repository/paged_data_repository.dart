import 'dart:async';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter_template/data/storage%20/model/paging_order.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/repository.dart';

abstract class PagedDataRepository<T> extends Repository {
  static const DEFAULT_PAGE_LIMIT = 20;
  PagingOrder pagingOrder;
  PagedDataCache<T>? cache;

  PagedDataRepository(this.pagingOrder, this.cache);

  int pageLimit = DEFAULT_PAGE_LIMIT;
  int? nextCursor;

  bool get isOnFirstPage =>
      nextCursor == null || pagingOrder == PagingOrder.asc && nextCursor == 0;
  bool noMoreItems = false;
  bool isLoadingTopPages = false;

  final streamController = StreamController<List<T>>.broadcast();

  List<T> itemsList = [];

  @override
  Future<List<T>> update() async {
    try {
      itemsList = [];
      noMoreItems = false;
      nextCursor = null;
      await loadMore(force: true);
      return Future.value(itemsList);
    } catch (e, s) {
      print(e);
      print(s);
      return Future.error(e);
    }
  }

  Future<DataPage<T>> getCachedPage(int? nextCursor) {
    var page = cache?.getPage(pageLimit, nextCursor, pagingOrder);
    if (page == null) {
      page = Future.value(DataPage(nextCursor?.toString(), List.empty(), true));
    }

    return page;
  }

  Future<DataPage<T>> getAndCacheRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    return getRemotePage(nextCursor, requiredOrder); //TODO cache data
  }

  Future<DataPage<T>> getRemotePage(int? nextCursor, PagingOrder requiredOrder);

  cachePage(DataPage<T> page) {
    cache?.cachePage(page);
  }

  Future<List<T>> loadMore({bool force = false}) async {
    if ((noMoreItems || (isLoading && !isLoadingTopPages)) && !force) {
      return Future.value(List.empty());
    }
    return getCachedPage(nextCursor).then((cachedPage) async {
      if (cachedPage.isLast) {
        log('Cached page is last');
        var res = await getAndCacheRemotePage(nextCursor, pagingOrder);
        onNewPage(res);
        return res.items;
      } else {
        return cachedPage.items;
      }
    });
  }

  onNewPage(DataPage<T> page) {
    isNeverUpdated = false;
    noMoreItems = page.isLast;
    nextCursor = page.nextCursor != null ? int.parse(page.nextCursor!) : null;
    itemsList.addAll(page.items);
    streamController.sink.add(itemsList);
  }
}
