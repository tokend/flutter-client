abstract class ObjectPersistence<T> {
  Future<T?> loadItem();

  saveItem(T item);

  bool hasItem();

  clear();
}
