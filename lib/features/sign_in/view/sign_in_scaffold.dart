import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_form.dart';

class SignInScaffold extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => SignInBloc(env),
        child: SignInForm(),
      ),
    ));
  }
}
