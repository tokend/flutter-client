import 'dart:convert';

import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectPersistenceOnPrefs<T> implements ObjectPersistence<T> {
  SharedPreferences sharedPreferences;
  String key;

  ObjectPersistenceOnPrefs(this.sharedPreferences, this.key);

  T? loadedItem;

  @override
  clear() async {
    loadedItem = null;
    sharedPreferences.remove(key);
  }

  @override
  bool hasItem() {
    return loadItem() != null;
  }

  @override
  T? loadItem() {
    var item = loadedItem;
    if (item == null) {
      var savedItemJson = sharedPreferences.getString(key);
      if (savedItemJson == null) savedItemJson = '';
      item = json.decode(savedItemJson);
      if (item != null) loadedItem = item;
    }
  }

  @override
  saveItem(T item) async {
    loadedItem = item;
    sharedPreferences.setString(key, json.encode(item));
  }
}
