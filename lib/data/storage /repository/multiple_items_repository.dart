import 'dart:async';
import 'dart:developer';

import 'package:flutter_template/data/storage%20/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

/// Repository that holds a list of [T] items.
abstract class MultipleItemsRepository<T> extends Repository {
  Future<List<T>> getItems();

  Lock lock = new Lock();

  final streamSubject = BehaviorSubject<List<T>>();
  final singleSubject = BehaviorSubject<T>();

  //TODO implement items ensuring

  Future<void> update() async {
    invalidate();
    await getItems().then((items) {
      streamSubject.add(items);

      onNewItems(items);
      isLoading = false;
    }).onError((error, stackTrace) {
      log(stackTrace.toString());
    });
  }

  onNewItems(List<T> newItems) {
    isNeverUpdated = false;
    isFresh = true;

    cacheNewItems(newItems);
  }

  //TODO items caching
  cacheNewItems(List<T> newItems) {}
}
