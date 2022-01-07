import 'dart:convert';
import 'dart:developer';

import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';

/// Manages network configuration of the app.
class UrlConfigManager {
  UrlConfigProvider urlConfigProvider;
  ObjectPersistence<UrlConfig> urlConfigPersistence;

  UrlConfigManager(this.urlConfigProvider, this.urlConfigPersistence);

  /// Return [UrlConfig] selected by user, null if it is absent or selection is unsupported
  UrlConfig? getConfig() {
    if (urlConfigProvider.hasConfig()) return urlConfigProvider.getConfig();
  }

  /// Sets given config to the provider and saves it to the persist
  bool setFromJson(String jsonConfig) {
    try {
      var config = UrlConfig.fromJson(json.decode(jsonConfig));
      urlConfigProvider.setConfig(config);
      urlConfigPersistence.saveItem(config);

      return true;
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      return false;
    }
  }
}
