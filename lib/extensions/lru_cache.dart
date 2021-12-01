import 'package:dcache/dcache.dart';

extension LruCacheForMultipleRepositories<K, V> on LruCache {
  V getOrPut(K key, V value) {
    var existingValue = get(key);
    if (existingValue == null) {
      set(key, value);
      return value;
    }

    return existingValue;
  }
}
