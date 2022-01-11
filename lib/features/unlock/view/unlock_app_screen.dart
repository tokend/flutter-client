import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/view/auth_screen_template.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/models/email.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:flutter_template/utils/view/password_text_field.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

class UnlockAppScaffold extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => SignInBloc(
          env,
          SignInState(
              Email.dirty(value: credentialsPersistence.getSavedEmail()!),
              Password.pure(),
              network: env.apiUrl),
        ),
        child: UnlockAppScreen(),
      ),
    ));
  }
}

class UnlockAppScreen extends BaseStatefulWidget {
  @override
  VisibilityAwareState<UnlockAppScreen> createState() =>
      _UnlockAppScreenState();
}

class _UnlockAppScreenState extends VisibilityAwareState<UnlockAppScreen> {
  GlobalKey<DefaultButtonState> _unlockButtonKey =
      GlobalKey<DefaultButtonState>();

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    if (visibility == WidgetVisibility.INVISIBLE) {
      log((describeEnum(visibility)));

      setState(() {}); //call build() again in order to implement fingerprint
    }
    super.onVisibilityChanged(visibility);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        final colorTheme = context.colorTheme;
        final screenSize = MediaQuery.of(context).size;
        var progress;

        void checkIfAuthPossible() async {
          var msg = '';
          try {
            bool hasBiometrics =
                await widget.localAuthentication.canCheckBiometrics;

            if (hasBiometrics) {
              List<BiometricType> availableBiometrics =
                  await widget.localAuthentication.getAvailableBiometrics();
              var credentials =
                  await widget.credentialsPersistence.getCredentials();

              if (Platform.isIOS) {
                if (availableBiometrics.contains(BiometricType.face)) {
                  bool pass = await widget.localAuthentication.authenticate(
                      localizedReason: 'finger_print_hint'.tr,
                      biometricOnly: true);

                  if (pass) {
                    context
                        .read<SignInBloc>()
                        .add(PasswordChanged(password: credentials.item2));

                    context.read<SignInBloc>().add(FormSubmitted(
                        email: state.email.value,
                        password: state.password.value));
                  }
                }
              } else {
                if (availableBiometrics.contains(BiometricType.fingerprint)) {
                  bool pass = await widget.localAuthentication.authenticate(
                      localizedReason: 'finger_print_hint'.tr,
                      biometricOnly: true);
                  if (pass) {
                    context
                        .read<SignInBloc>()
                        .add(PasswordChanged(password: credentials.item2));

                    context.read<SignInBloc>().add(FormSubmitted(
                        email: state.email.value,
                        password: state.password.value));
                    //Get.toNamed('/home');
                  }
                } else {
                  log('Android BiometricType.fingerprint not allowed');
                }
              }
            } else {
              msg = "You are not allowed to access biometrics.";
            }
          } on PlatformException catch (e) {
            msg = "Error while opening fingerprint/face scanner";
            log(e.stacktrace.toString() + ' ${e.code}');
          }

          log('message $msg');
        }

        checkIfAuthPossible();

        log('building unlock screen again');
        return ProgressHUD(
          child: Builder(builder: (contextBuilder) {
            Widget signInWidget = AuthScreenTemplate(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Sizes.standartPadding),
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
                            'unlock'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: Sizes.textSizeHeadingLarge,
                                color: colorTheme.accent),
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.01,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        _PasswordInputField(),
                        Padding(
                          padding:
                              EdgeInsets.only(top: Sizes.quartedStandartMargin),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: RichText(
                              text: TextSpan(
                                text: 'forgot_password'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: Sizes.textSizeHint,
                                    color: colorTheme.hint),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'recover_it'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Sizes.textSizeHint,
                                        color: colorTheme.accent),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => Get.toNamed('/recovery'),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenSize.height * 0.027,
                    ),
                    Column(
                      children: [
                        _UnlockButton(_unlockButtonKey),
                        Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.standartMargin)),
                        _ChangeAccountButton(signOut),
                        Container(
                          height: screenSize.height * 0.04,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );

            return BlocListener<SignInBloc, SignInState>(
                listener: (context, state) {
                  progress = ProgressHUD.of(contextBuilder);
                  if (state.status.isSubmissionInProgress) {
                    progress.show();
                  } else if (state.status.isValid) {
                    updateValidationState(
                        _unlockButtonKey, true, state.network);
                  } else if (state.status.isInvalid) {
                    updateValidationState(
                        _unlockButtonKey, false, state.network);
                  } else if (state.status.isSubmissionFailure) {
                    progress.dismiss();
                    print('submission failure');
                  } else if (state.status.isSubmissionSuccess) {
                    progress.dismiss();

                    if (state.hasKyc) {
                      Get.offAllNamed('/home');
                    } else {
                      Get.offAllNamed('/kycForm');
                    }
                  }
                },
                child: signInWidget);
          }),
        );
      },
    );
  }

  signOut({bool soft = false}) {
    //Delete all dependencies for current account
    widget.sharedPreferences.clear();
    Get.deleteAll();
    MainBindings(widget.env, widget.sharedPreferences).dependencies();

    Get.toNamed('/signIn');
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        print(state.password.error != null ? state.password.error!.name : null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: PasswordTextField(
            label: 'password_label'.tr,
            hint: 'password_hint'.tr,
            key: const Key('SignInForm_passwordInput_textField'),
            error: state.password.error != null
                ? state.password.error!.name
                : null,
            onChanged: (password) {
              context
                  .read<SignInBloc>()
                  .add(PasswordChanged(password: password));
            },
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _UnlockButton extends StatelessWidget {
  GlobalKey? parentKey;

  _UnlockButton(this.parentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return DefaultButton(
          key: parentKey,
          text: 'action_continue'.tr,
          defaultState: false,
          onPressed: () {
            state.status.isValidated
                ? context.read<SignInBloc>().add(FormSubmitted(
                    email: state.email.value, password: state.password.value))
                : null;
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}

class _ChangeAccountButton extends StatelessWidget {
  Function callback;

  _ChangeAccountButton(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0), //Defines Elevation
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 56)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.xSmallRadius),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(colorTheme.secondaryText),
      ),
      onPressed: () => callback.call(),
      child: Text(
        'change_account'.tr,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Sizes.textSizeDialog,
            color: colorTheme.primary),
      ),
    );
  }
}

updateValidationState(
    GlobalKey<DefaultButtonState> key, bool isFormValid, String network) {
  key.currentState?.setIsEnabled(isFormValid && network.isNotEmpty);
}
