import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/features/sign_up/logic/sign_up_usecase.dart';
import 'package:flutter_template/features/sign_up/model/confirm_password.dart';
import 'package:flutter_template/features/sign_up/model/email.dart';
import 'package:flutter_template/features/sign_up/model/password.dart';
import 'package:formz/formz.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState());

  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(event.email!);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmPassword,
        ]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password!);
      final confirm = ConfirmPassword.dirty(
        password: password.value,
        value: state.confirmPassword.value,
      );
      yield state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
          confirm,
        ]),
      );
    } else if (event is ConfirmPasswordChanged) {
      print("ConfPassEvent -> $event");
      final password = ConfirmPassword.dirty(
          password: state.password.value, value: event.confirmPassword!);
      yield state.copyWith(
        confirmPassword: password,
        status: Formz.validate([
          state.email,
          state.password,
          password,
        ]),
      );
    } else if (event is FormSubmitted) {
      if (!state.status.isValidated) return;
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        //TODO
        var api = TokenDApi('http://d631-193-19-228-94.ngrok.io/_/api/');
        var keyServer = KeyServer(api.wallets);
        await SignUpUseCase(
                state.email.value, state.password.value, keyServer, api)
            .perform()
            .then((wallet) => log('ID:  ${wallet.walletData.id}'));
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
