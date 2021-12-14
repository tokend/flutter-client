import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

/// Repository that holds a single [T] item.
abstract class SingleItemRepository<T> extends Repository {
  ObjectPersistence<T>? objectPersistence;

  /// Repository item
  T? item;
  final streamSubject = BehaviorSubject<T>();

  Future<T> getItem();

  Lock lock = new Lock();

  final streamSubject = BehaviorSubject<T>();

  T? getStoredItem() {
    if (objectPersistence == null) return null;
    return objectPersistence!.loadItem();
  }

  storeItem(T item) => objectPersistence?.saveItem(item);

  //TODO ??
  broadcast() {}

  onNewItem(T newItem) {
    isNeverUpdated = false;
    isFresh = true;

    item = newItem;
  }

  //TODO implement items ensuring

  @override
  Future<void> update() {
    invalidate();

    return lock.synchronized(() {
      T? storedItem;
      if (isNeverUpdated) {
        storedItem = getStoredItem();
      }

      getItem().then((item) => storeItem(item)).then((item) {
        streamSubject.add(item);
        isNeverUpdated = false;
        isLoading = false;
        onNewItem(item);
      });
      //TODO return value  ?
    });
  }

  set(T item) {
    onNewItem(item);
    storeItem(item);
  }
}
