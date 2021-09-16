import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/sign_up/model/confirm_password.dart';
import 'package:flutter_template/features/sign_up/model/email.dart';
import 'package:flutter_template/features/sign_up/model/password.dart';
import 'package:formz/formz.dart';

import 'auth_text_field.dart';
import 'logic/sign_up_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            print('submission failure');
          } else if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pushNamed('sign_in');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EmailInputField(),
              _PasswordInputField(),
              _ConfirmPasswordInput(),
              _SignUpButton(),
            ],
          ),
        ));
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Email',
            key: const Key('signUpForm_emailInput_textField'),
            isRequiredField: true,
            keyboardType: TextInputType.emailAddress,
            error: state.email.error != null ? state.email.error!.name : null,
            onChanged: (email) =>
                context.read<SignUpBloc>().add(EmailChanged(email: email)),
          ),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        print(state.password.error != null ? state.password.error!.name : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: AuthTextField(
            hint: 'Password',
            key: const Key('signUpForm_passwordInput_textField'),
            isPasswordField: true,
            isRequiredField: true,
            keyboardType: TextInputType.text,
            error: state.password.error != null
                ? state.password.error!.name
                : null,
            onChanged: (password) => context
                .read<SignUpBloc>()
                    .add(PasswordChanged(password: password)),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        print(
            "TEST CONFITM -> ${state.confirmPassword.error != null ? state.confirmPassword.error!.name : null}");
        return AuthTextField(
          hint: 'Confirm Password',
          isRequiredField: true,
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          isPasswordField: true,
          keyboardType: TextInputType.text,
          error: state.confirmPassword.error != null
              ? state.confirmPassword.error!.name
              : null,
          onChanged: (confirmPassword) => context
              .read<SignUpBloc>()
                  .add(ConfirmPasswordChanged(confirmPassword: confirmPassword)),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('Sign Up'),
            disabledColor: Colors.blueAccent.withOpacity(0.6),
            color: Colors.blueAccent,
            onPressed: state.status.isValidated
                ? () => context.read<SignUpBloc>().add(FormSubmitted())
                : null,
          ),
        );
      },
    );
  }
}
