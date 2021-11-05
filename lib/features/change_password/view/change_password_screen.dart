import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_bloc.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_event.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_state.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:flutter_template/utils/view/password_text_field.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

GlobalKey<DefaultButtonState> _saveChangesButtonKey =
    GlobalKey<DefaultButtonState>();

class ChangePasswordScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        iconTheme: IconThemeData(color: context.colorTheme.accent),
        title: Text(
          'change_password'.tr,
          style:
              TextStyle(color: context.colorTheme.primaryText, fontSize: 17.0),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: BlocProvider(
          create: (_) => ChangePasswordBloc(ChangePasswordState(Password.pure(),
              Password.pure(), Password.pure(), FormzStatus.pure)),
          child: ChangePasswordScreen(),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    var progress;

    return ProgressHUD(
      child: Builder(builder: (contextBuilder) {
        Widget signInWidget = Container(
          color: colorTheme.background,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.standartPadding),
            child: Container(
                color: colorTheme.background,
                child: Stack(children: [
                  Column(
                    children: [
                      _OldPasswordInputField(),
                      Padding(
                          padding: EdgeInsets.only(top: Sizes.standartMargin)),
                      _NewPasswordInputField(),
                      Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin),
                      ),
                      _RepeatPasswordInputField(),
                      Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: _ChangePasswordButton(_saveChangesButtonKey),
                    ),
                  )
                ])),
          ),
        );

        return BlocListener<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              progress = ProgressHUD.of(contextBuilder);
              if (state.status.isSubmissionInProgress) {
                progress.show();
              } else if (state.status.isValid) {
                updateValidationState(true);
              } else if (state.status.isInvalid) {
                updateValidationState(false);
              } else if (state.status.isSubmissionFailure) {
                progress.dismiss();
                print('submission failure');
              } else if (state.status.isSubmissionSuccess) {
                progress.dismiss();
                Get.offAllNamed('/home');
              }
            },
            child: signInWidget);
      }),
    );
  }
}

class _OldPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.oldPassword != current.oldPassword,
      builder: (context, state) {
        print(state.oldPassword.error != null
            ? state.oldPassword.error!.name
            : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: PasswordTextField(
            label: 'current_password'.tr,
            hint: 'password_hint'.tr,
            key: const Key('ChangePasswordForm_oldPasswordInput_textField'),
            error: state.oldPassword.error != null
                ? state.oldPassword.error!.name
                : null,
            onChanged: (password) {
              context
                  .read<ChangePasswordBloc>()
                  .add(OldPasswordChanged(password));
            },
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _NewPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.oldPassword != current.oldPassword,
      builder: (context, state) {
        print(state.oldPassword.error != null
            ? state.oldPassword.error!.name
            : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: PasswordTextField(
            label: 'new_password'.tr,
            hint: 'password_hint'.tr,
            key: const Key('ChangePasswordForm_newPasswordInput_textField'),
            error: state.oldPassword.error != null
                ? state.oldPassword.error!.name
                : null,
            onChanged: (password) {
              context
                  .read<ChangePasswordBloc>()
                  .add(OldPasswordChanged(password));
            },
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _RepeatPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.oldPassword != current.oldPassword,
      builder: (context, state) {
        print(state.oldPassword.error != null
            ? state.oldPassword.error!.name
            : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: PasswordTextField(
            label: 'repeat_new_password'.tr,
            hint: 'password_hint'.tr,
            key: const Key('ChangePasswordForm_repeatPasswordInput_textField'),
            error: state.oldPassword.error != null
                ? state.oldPassword.error!.name
                : null,
            onChanged: (password) {
              context
                  .read<ChangePasswordBloc>()
                  .add(OldPasswordChanged(password));
            },
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _ChangePasswordButton extends StatelessWidget {
  GlobalKey? parentKey;

  _ChangePasswordButton(this.parentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return DefaultButton(
          key: parentKey,
          text: 'save_changes'.tr,
          defaultState: false,
          onPressed: () {
            state.status.isValidated
                ? context.read<ChangePasswordBloc>().add(FormSubmitted(
                    state.oldPassword.value,
                    state.newPassword.value,
                    state.repeatPassword.value))
                : null;
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}

updateValidationState(bool isFormValid) {
  _saveChangesButtonKey.currentState?.setIsEnabled(isFormValid);
}
