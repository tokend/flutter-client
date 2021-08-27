import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/development.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_screen.dart';

import 'config/env.dart';

void main() {
  runApp(App(Development()));
}

class App extends StatelessWidget {
  final Env env;

  App(this.env);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TEST",
      home: SignInScreen(),
    );
  }
}
