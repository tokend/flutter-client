import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/sign_up/model/confirm_password.dart';
import 'package:flutter_template/features/sign_up/model/email.dart';
import 'package:flutter_template/features/sign_up/model/password.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/password_text_field.dart';
import 'package:flutter_template/utils/view/sign_in_screen_template.dart';
import 'package:formz/formz.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'logic/sign_up_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            print('submission failure');
          } else if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pushNamed('sign_in');
          }
        },
        child: SignInScreenTemplate(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.standartPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: screenSize.height * 0.1,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'title_sign_up'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.textSizeTitle,
                            color: colorTheme.primary),
                      ),
                    ),
                    Container(
                      height: screenSize.height * 0.01,
                    ),
                  ],
                ),
                Column(
                  children: [
                    _EmailInputField(),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                    ),
                    _PasswordInputField(),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                    ),
                    _ConfirmPasswordInput(),
                  ],
                ),
                Container(
                  height: screenSize.height * 0.027,
                ),
                Column(
                  children: [
                    _SignUpButton(),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin)),
                    GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have account? ',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Sizes.textSizeHint,
                              color: colorTheme.hint),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.textSizeHint,
                                  color: colorTheme.accent),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    Container(
                      height: screenSize.height * 0.04,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            hint: 'Email',
            inputType: TextInputType.emailAddress,
            key: const Key('signUpForm_emailInput_textField'),
            error: state.email.error != null ? state.email.error!.name : null,
            onChanged: (email) =>
                context.read<SignUpBloc>().add(EmailChanged(email: email)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        print(state.password.error != null ? state.password.error!.name : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: PasswordTextField(
            hint: 'Password',
            key: const Key('signUpForm_passwordInput_textField'),
            error: state.password.error != null
                ? state.password.error!.name
                : null,
            onChanged: (password) => context
                .read<SignUpBloc>()
                .add(PasswordChanged(password: password)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        print(
            "TEST CONFITM -> ${state.confirmPassword.error != null ? state.confirmPassword.error!.name : null}");
        return PasswordTextField(
          hint: 'Confirm Password',
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          error: state.confirmPassword.error != null
              ? state.confirmPassword.error!.name
              : null,
          onChanged: (confirmPassword) => context
              .read<SignUpBloc>()
              .add(ConfirmPasswordChanged(confirmPassword: confirmPassword)),
          colorTheme: colorTheme,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return DefaultButton(
          text: 'Sign Up',
          onPressed: () {
            state.status.isValidated
                ? context.read<SignUpBloc>().add(FormSubmitted())
                : null;
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}
