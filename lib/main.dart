import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/home/view/home_screen.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/recovery/view/recovery_scaffold.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:get/get.dart';

import 'config/env.dart';

void main() {
  runApp(App(Development()));
}

class App extends StatelessWidget {
  final Env env;

  App(this.env);

  @override
  Widget build(BuildContext context) {
    MainBindings(env).dependencies();
    return GetMaterialApp(
      title: 'Flutter Client',
      locale: Get.deviceLocale,
      translations: AppTranslation(),
      fallbackLocale: Locale('en', 'US'),
      routes: {
        'sign_in': (context) => SignInScaffold(),
        'sign_up': (context) => SignUpScaffold(),
      },
      home: HomeScreen(),
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
        GetPage(
            name: '/recovery',
            page: () => RecoveryScaffold(),
            binding: MainBindings(env)),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            binding: MainBindings(env)),
      ],
    );
  }
}
