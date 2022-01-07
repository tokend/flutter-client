import 'dart:developer';

import 'package:dart_sdk/api/wallets/model/exceptions.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/kyc/model/active_kyc.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_usecase.dart';
import 'package:flutter_template/utils/view/models/email.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart' as getX;

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
  SignInBloc(this.env, SignInState state) : super(state);
  Env env;

  @override
  Future<void> onTransition(
      Transition<SignInEvent, SignInState> transition) async {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(value: event.email!);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
        ]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(value: event.password!);
      yield state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
        ]),
      );
    } else if (event is NetworkChanged) {
      env.apiUrl = event.network!;
      getX.Get.put(env);

      yield state.copyWith(
        network: event.network,
      );
    } else if (event is FormSubmitted) {
      if (!state.status.isValidated) return;
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        var api = apiProvider.getApi();
        var keyServer = KeyServer(api.wallets);
        await SignInUseCase(state.email.value, state.password.value, keyServer,
                session, credentialsPersistence, walletInfoPersistence)
            .perform();
        await repositoryProvider.activeKyc.getItem();
        var kycState = await hasKyc();
        yield state.copyWith(
            status: FormzStatus.submissionSuccess, hasKyc: kycState);
      } catch (e, stacktrace) {
        log(stacktrace.toString());
        if (e is InvalidCredentialsException) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            password: Password.dirty(serverError: e),
            hasKyc: false,
          );
        } else if (e is EmailNotVerifiedException) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            email: Email.dirty(serverError: e),
            hasKyc: false,
          );
        }
      }
    } else if (event is NotFirstLogIn) {
      try {
        var api = apiProvider.getApi();
        var keyServer = KeyServer(api.wallets);
        var savedPassword = await event.password;
        await SignInUseCase(event.email!, savedPassword!, keyServer, session,
                credentialsPersistence, walletInfoPersistence)
            .perform();

        var kycState = await hasKyc();
        yield state.copyWith(
            status: FormzStatus.submissionSuccess, hasKyc: kycState);
      } on Exception {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Future<bool> hasKyc() async {
    var form = await repositoryProvider.activeKyc.getItem();
    return form is ActiveKycForm;
  }
}
