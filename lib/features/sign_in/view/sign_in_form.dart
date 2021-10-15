import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:flutter_template/utils/view/auth_screen_template.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/models/email.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:flutter_template/utils/view/password_text_field.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SignInForm extends StatelessWidget {
  SignInForm({Key? key}) : super(key: key);
  GlobalKey<DefaultButtonState> _signInButtonKey =
      GlobalKey<DefaultButtonState>();

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    final screenSize = MediaQuery.of(context).size;
    var progress;

    return ProgressHUD(
      child: Builder(builder: (contextBuilder) {
        Widget signInWidget = AuthScreenTemplate(
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
                        'title_sign_in'.tr,
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
                    _NetworkInputField(),
                    Padding(
                        padding:
                            EdgeInsets.only(top: Sizes.halfStandartPadding)),
                    _EmailInputField(),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                    ),
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
                    _SignInButton(_signInButtonKey),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin)),
                    GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          text: 'dont_have_account'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Sizes.textSizeHint,
                              color: colorTheme.hint),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'action_register'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.textSizeHint,
                                  color: colorTheme.accent),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Get.toNamed('/signUp'),
                    ),
                    Container(
                      height: screenSize.height * 0.04,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (isSignedIn()) {
          //TODO simplify
          signInWidget =
              _LoggedInUseCase(); // Actually no widget, but going to Home screen
        }

        return BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              progress = ProgressHUD.of(contextBuilder);
              if (state.status.isSubmissionInProgress) {
                progress.show();
              } else if (state.status.isValid) {
                updateValidationState(_signInButtonKey, true, state.network);
              } else if (state.status.isInvalid) {
                updateValidationState(_signInButtonKey, false, state.network);
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

class _NetworkInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    Env env = Get.find();
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.network != current.network,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: DefaultTextField(
                key: const Key('SignInForm_networkInput_textField'),
                onChanged: (network) {
                  context.read<SignInBloc>().add(NetworkChanged(network));
                },
                label: "network_label".tr,
                defaultText: env.apiUrl,
                suffixIcon: IconButton(
                  icon: Icon(CustomIcons.scan_barcode),
                  onPressed: () {
                    Get.toNamed('/qr', preventDuplicates: false);
                  },
                ),
                colorTheme: colorTheme),
          );
        });
  }
}

class _LoggedInUseCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CredentialsPersistence credentialsPersistence = Get.find();

    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        context.read<SignInBloc>().add(NotFirstLogIn(
            email: credentialsPersistence.getSavedEmail(),
            password: credentialsPersistence.getSavedPassword()));
        return Padding(
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'email_label'.tr,
            hint: 'email_hint'.tr,
            inputType: TextInputType.emailAddress,
            key: const Key('SignInForm_emailInput_textField'),
            error: state.email.error != null ? state.email.error!.name : null,
            onChanged: (email) {
              context.read<SignInBloc>().add(EmailChanged(email));
            },
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

class _SignInButton extends StatelessWidget {
  GlobalKey? parentKey;

  _SignInButton(this.parentKey, {Key? key}) : super(key: key);

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

updateValidationState(
    GlobalKey<DefaultButtonState> key, bool isFormValid, String network) {
  key.currentState?.setIsEnabled(isFormValid && network.isNotEmpty);
}

bool isSignedIn() {
  CredentialsPersistence credentialsPersistence = Get.find();
  if (credentialsPersistence.getSavedEmail() != null) {
    return true;
  }
  return false;
}
