import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:flutter_template/utils/routing/page_router.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/env.dart';
import 'features/sign_in/view/sign_in_scaffold.dart';

Future<void> main() async {
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
        theme: ThemeData(
            backgroundColor: context.colorTheme.background,
            scaffoldBackgroundColor: context.colorTheme.background),
        title: 'Flutter Client',
        locale: Get.deviceLocale,
        translations: AppTranslation(),
        fallbackLocale: Locale('en', 'US'),
        home: SignInScaffold(),
        getPages: getPageList(env, sharedPreferences, binding));
  }
}
