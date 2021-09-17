import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';

class UrlConfigProviderImpl implements UrlConfigProvider {
  UrlConfig? config;

  @override
  UrlConfig getConfig() {
    return config!;
  }

  @override
  bool hasConfig() {
    return config != null;
  }

  @override
  setConfig(UrlConfig config) {
    this.config = config;
  }
}
