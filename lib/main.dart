import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/balances/view/balances_screen.dart';
import 'package:flutter_template/features/home/view/home_screen.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/recovery/view/recovery_scaffold.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:flutter_template/utils/routing/page_router.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/env.dart';
import 'features/kyc/view/kyc_scaffold.dart';

Future<void> main() async{
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ),
  );
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
        // home: SignInScaffold(),
        home: KycScaffold(),
        // home: SignUpScaffold(),
        getPages: getPageList(env));
  }
}
