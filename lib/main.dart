import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/balances/view/balances_screen.dart';
import 'package:flutter_template/features/home/view/home_screen.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/recovery/view/recovery_scaffold.dart';
import 'package:flutter_template/features/settings/view/settings_screen.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(App(Development(sharedPreferences), sharedPreferences));
}

class App extends StatelessWidget {
  final Env env;
  final SharedPreferences sharedPreferences;

  App(this.env, this.sharedPreferences);

  @override
  Widget build(BuildContext context) {
    MainBindings(env, sharedPreferences).dependencies();
    var binding = MainBindings(env, sharedPreferences);
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
            name: '/signIn', page: () => SignInScaffold(), binding: binding),
        GetPage(
            name: '/signUp', page: () => SignUpScaffold(), binding: binding),
        GetPage(
            name: '/qr', page: () => ScanNetworkQrUseCase(), binding: binding),
        GetPage(
            name: '/recovery',
            page: () => RecoveryScaffold(),
            binding: binding),
        GetPage(name: '/home', page: () => HomeScreen(), binding: binding),
        GetPage(
            name: '/balances',
            page: () => BalancesScreen(false),
            binding: binding),
        GetPage(
            name: '/settings', page: () => SettingsScreen(), binding: binding),
      ],
    );
  }
}
