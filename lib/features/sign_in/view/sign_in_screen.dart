import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/utils/view/base_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInCreateState createState() => _SignInCreateState();
}

class _SignInCreateState extends BaseState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = context.appLocalization;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.app_title),
      ),
      backgroundColor: Color(0xFFFF5000),
      body: Center(
        child: Text(localization.sign_in_text),
      ),
    );
  }
}
