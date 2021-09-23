import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/utils/view/models/confirm_password.dart';
import 'package:flutter_template/utils/view/models/email.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:formz/formz.dart';

part 'recovery_event.dart';

part 'recovery_state.dart';

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  RecoveryBloc() : super(RecoveryState());

  @override
  void onTransition(Transition<RecoveryEvent, RecoveryState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<RecoveryState> mapEventToState(
    RecoveryEvent event,
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
      Future.delayed(Duration(seconds: 3));
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}
