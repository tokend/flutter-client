import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:flutter_template/utils/connection_state.dart' as connection;
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';

import 'config/env.dart';

void main() {
  runApp(App(Development()));
}

class App extends StatelessWidget {
  final Env env;

  App(this.env);

  Map _source = {ConnectivityResult.none: false};
  final connection.ConnectionState _connectivity =
      connection.ConnectionState.instance;

  @override
  Widget build(BuildContext context) {
    MainBindings(env).dependencies();
    ToastManager toastManager = Get.find();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      _source.clear();
      _source = source;
      if (source.keys.toList().length > 0 &&
          source.keys.toList()[0] == ConnectivityResult.none) {
        toastManager.showShortToast('error_device_offline'.tr);
      }
    });
    return GetMaterialApp(
      title: 'Flutter Client',
      locale: Get.deviceLocale,
      translations: AppTranslation(),
      fallbackLocale: Locale('en', 'US'),
      routes: {
        'sign_in': (context) => SignInScaffold(),
        'sign_up': (context) => SignUpScaffold(),
      },
      home: SignInScaffold(),
      getPages: [
        GetPage(
            name: '/signIn',
            page: () => SignInScaffold(),
            binding: MainBindings(env)),
        GetPage(
            name: '/signUp',
            page: () => SignUpScaffold(),
            binding: MainBindings(env)),
        GetPage(
            name: '/qr',
            page: () => ScanNetworkQrUseCase(),
            binding: MainBindings(env)),
      ],
    );
  }
}
