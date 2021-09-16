import 'package:flutter/material.dart';
import 'package:flutter_template/utils/view/base_state.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInCreateState createState() => _SignInCreateState();
}

class _SignInCreateState extends BaseState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
      ),
      backgroundColor: Color(0xFFFF5000),
      body: Center(
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "sign_up");
              },
              child: Text('sign_in_text'.tr))),
    );
  }
}
