abstract class ObjectPersistence<T> {
  T? loadItem();

  saveItem(T item);

  bool hasItem();

  clear();
}
