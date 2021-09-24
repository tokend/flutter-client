import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';

abstract class Env {
  static late Env value;

  // API URL - TokenD instance root URL
  abstract String apiUrl;

  // Storage URL - Root URL of file storage
  abstract String storageUrl;

  // App host - Host of the related web-client,
  // used to open verification and referral links in app
  abstract String appHost;

  // Client URL - URL of the related web-client
  abstract String clientUrl;

  // Auto logout timer in milliseconds.
  // App will logout after being in background during this time.
  // 0 means option is disabled
  abstract int logoutTime;

  bool withLogs = true;

  //Theme color
  abstract Color primarySwatch;

  Env() {
    value = this;
    runApp(App(this));
  }

  // Current env name
  String get name => runtimeType.toString();
}
