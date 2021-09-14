import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/sign_up/sign_up_form.dart';

import 'logic/sign_up_bloc.dart';

class SignUpScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          elevation: 0,
        ),
        body: SafeArea(
          top: false,
          child: BlocProvider(
            create: (_) => SignUpBloc(),
            child: SignUpForm(),
          ),
        ));
  }
}
