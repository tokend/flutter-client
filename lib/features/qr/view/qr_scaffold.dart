import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/qr/logic/qr_screen.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:get/get.dart';

class QrScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Env env = Get.find();
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => SignInBloc(env),
        child: QRScreen(),
      ),
    ));
  }
}
