import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/localisation/app_translation.dart';
import 'package:flutter_template/utils/routing/page_router.dart';
import 'package:get/get.dart';

import 'config/env.dart';
import 'features/kyc/view/kyc_scaffold.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ),
  );
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
        // home: SignInScaffold(),
        home: KycScaffold(),
        // home: SignUpScaffold(),
        getPages: getPageList(env));
  }
}
