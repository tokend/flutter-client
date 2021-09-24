import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/recovery/logic/recovery_bloc.dart';
import 'package:flutter_template/features/recovery/view/recovery_form.dart';

class RecoveryScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => RecoveryBloc(),
        child: RecoveryForm(),
      ),
    ));
  }
}
