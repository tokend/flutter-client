import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';

/// Allow to get all specific paged data at once.
///
/// [distinct] enables filter by distinct
/// based on [Object.equals] and [Object.hashCode] to avoid
/// duplicates on page-number-based pagination

abstract class PagedResourceLoader<T> {
  String? nextCursor;
  bool noMoreItems = false;
  bool distinct = true;

  PagedResourceLoader(this.distinct);

  /// Provides api request to get [DataPage] of specific resource.
  /// [nextCursor] cursor or number for the next page
  Future<DataPage<T>> getPageRequest(String? nextCursor);

  /// Return request that will load all data page by page,
  /// and then return it as list.
  Future<List<T>> loadAll() async {
    List<T> result = [];
    var page = await getPageRequest(nextCursor);
    result.addAll(page.items);
    log('Page items: ${page.items}');
    log('Page items1: ${result.toList()}');
    nextCursor = page.nextCursor;
    noMoreItems = page.isLast;
    log('NoMoreItems??? $noMoreItems');

    while (!noMoreItems) {}

    return result.toList();
  }
}
