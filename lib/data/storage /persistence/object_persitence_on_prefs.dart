import 'dart:convert';

import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectPersistenceOnPrefs<T> implements ObjectPersistence<T> {
  Future<SharedPreferences> sharedPreferences;
  String key;

  ObjectPersistenceOnPrefs(this.sharedPreferences, this.key);

  T? loadedItem;

  @override
  clear() async {
    loadedItem = null;
    (await sharedPreferences).remove(key);
  }

  @override
  bool hasItem() {
    return loadItem() != null;
  }

  @override
  Future<T?> loadItem() async {
    var item = loadedItem;
    if (item == null) {
      var savedItemJson = (await sharedPreferences).getString(key);
      if (savedItemJson == null) savedItemJson = '';
      item = json.decode(savedItemJson);
      if (item != null) loadedItem = item;
    }
  }

  @override
  saveItem(T item) async {
    loadedItem = item;
    (await sharedPreferences).setString(key, json.encode(item));
  }
}
