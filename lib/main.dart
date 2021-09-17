import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_screen.dart';
import 'package:flutter_template/features/sign_up/sign_up_scaffold.dart';
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
      translationsKeys: AppTranslation.translationsKeys,
      routes: {
        'sign_in': (context) => SignInScreen(),
        'sign_up': (context) => SignUpScaffold(),
        // 'sign_up': (context) => SignUpScreen(),
        // '/home': (context) => HomeScaffold(),
      },
      home: SignInScreen(),
      getPages: [GetPage(name: '/signIn', page: () => SignInScreen(), binding: MainBindings(env))],
    );
  }
}
