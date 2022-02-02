import 'dart:developer';

import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_event.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_state.dart';
import 'package:flutter_template/features/change_password/logic/change_password_usecase.dart';
import 'package:flutter_template/utils/view/models/confirm_password.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:formz/formz.dart';

class ChangePasswordBloc
    extends BaseBloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(initialState) : super(initialState);

  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is OldPasswordChanged) {
      final password = Password.dirty(value: event.oldPassword!);
      yield state.copyWith(
        oldPassword: password,
        status: Formz.validate([
          password,
          state.newPassword,
          state.repeatPassword,
        ]),
      );
    } else if (event is NewPasswordChanged) {
      final newPassword = Password.dirty(value: event.newPassword!);
      yield state.copyWith(
        newPassword: newPassword,
        status: Formz.validate([
          state.oldPassword,
          newPassword,
          state.repeatPassword,
        ]),
      );
    } else if (event is RepeatPasswordChanged) {
      final repeatPassword = ConfirmPassword.dirty(
          password: state.newPassword.value, value: event.repeatPassword!);
      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate([
          state.oldPassword,
          state.newPassword,
          repeatPassword,
        ]),
      );
    } else if (event is FormSubmitted) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await ChangePasswordUseCase(
                state.newPassword.value,
                apiProvider,
                session.accountProvider,
                walletInfoPersistence,
                repositoryProvider,
                credentialsPersistence,
                session.walletInfoProvider)
            .perform();
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (e, s) {
        log(s.toString());
        yield state.copyWith(
            status: FormzStatus.submissionFailure,
            newPassword: Password.dirty(serverError: e as Exception));
      }
    }
  }
}
