import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/kyc/view/KycForm.dart';

class KycScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => KycBloc(),
        child: KycForm(),
      ),
    ));
  }
}
