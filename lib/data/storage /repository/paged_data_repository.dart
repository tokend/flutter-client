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

  @override
  update() {
    // TODO: implement update
    throw UnimplementedError();
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
    return getRemotePage(nextCursor, requiredOrder)
        .onError((error, stackTrace) => Future.error(error!))
        .then((page) => cachePage(page));
  }

  Future<DataPage<T>> getRemotePage(int? nextCursor, PagingOrder requiredOrder);

  cachePage(DataPage<T> page) {
    cache?.cachePage(page);
  }

  bool loadMore(bool force) {
    if ((noMoreItems || (isLoading && !isLoadingTopPages)) && !force) {
      return false;
    }
    var getPage;
    getCachedPage(nextCursor).then((cachedPage) {
      if (cachedPage.isLast) {
        print('Cached page is last');
        if (cachedPage.items.isNotEmpty) {}
        var wasOnFirstPage = isOnFirstPage;
        getPage = getAndCacheRemotePage(nextCursor, pagingOrder).then((page) {
          if ((pagingOrder == PagingOrder.asc || wasOnFirstPage) &&
              page.isLast) {
            isFresh = true;
          }
        });
      } else {
        getPage = Future.value(cachedPage);
      }
    });

    return true;
  }
}
