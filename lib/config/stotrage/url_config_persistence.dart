import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persitence_on_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlConfigPersistence extends ObjectPersistenceOnPrefs<UrlConfig> {
  UrlConfigPersistence(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'url_config');
}
