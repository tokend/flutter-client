import 'package:flutter_template/config/model/url_config.dart';

abstract class UrlConfigProvider {
  bool hasConfig();

  UrlConfig getConfig();

  setConfig(UrlConfig config);
}
