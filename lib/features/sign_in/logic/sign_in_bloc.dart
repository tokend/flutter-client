import 'package:dart_sdk/key_server/key_server.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_usecase.dart';
import 'package:flutter_template/utils/view/models/email.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:formz/formz.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
  SignInBloc(this.env) : super(SignInState(network: env.apiUrl));
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
      final email = Email.dirty(event.email!);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
        ]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password!);
      yield state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
        ]),
      );
    } else if (event is NetworkChanged) {
      env.apiUrl = event.network!;
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

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
