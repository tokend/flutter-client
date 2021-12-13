import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/kyc/logic/bloc/kyc_bloc.dart';
import 'package:flutter_template/features/kyc/view/kyc_form.dart';
import 'package:get/get.dart';

class KycScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Env env = Get.find();
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => KycBloc(env),
        child: KycForm(),
      ),
    ));
  }
}
