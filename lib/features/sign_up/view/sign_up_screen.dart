import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/validators/email_validator.dart';
import 'package:flutter_template/utils/validators/password_validator.dart';
import 'package:flutter_template/utils/view/base_state.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/password_text_field.dart';
import 'package:flutter_template/utils/view/sign_in_screen_template.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseState<SignUpScreen> {
  final _emailController = TextEditingController();

  final _passwordEditingController = TextEditingController();

  final _passwordConfirmEditingController = TextEditingController();

  final _passwordConfirmKey = GlobalKey<PasswordTextFieldState>();

  final _buttonKey = GlobalKey<DefaultButtonState>();

  @override
  void initState() {
    _emailController.addListener(_onFieldsEdit);
    _passwordEditingController.addListener(_onFieldsEdit);
    _passwordConfirmEditingController.addListener(_onFieldsEdit);
    super.initState();
  }

  void _onFieldsEdit() {
    _buttonKey.currentState?.setIsEnabled(
        EmailValidator.get().isValid(_emailController.text) &&
            PasswordValidator.get().isValid(_passwordEditingController.text) &&
            _passwordConfirmEditingController.text.trim().length > 0);
  }

  @override
  void afterBuild() {
    _onFieldsEdit();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordEditingController.dispose();
    _passwordConfirmEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;

    final screenSize = MediaQuery.of(context).size;

    return SignInScreenTemplate(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.standartPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Image column
            Column(
              children: [
                Container(
                  height: screenSize.height * 0.1,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "title_sign_up".tr,
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
            //TextFields column
            Column(
              children: [
                DefaultTextField(
                  validator: (value) {
                    if (EmailValidator.get().isValid(value) ||
                        value == null ||
                        value.isEmpty) {
                      return null;
                    } else {
                      return "Invalid email";
                    }
                  },
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  hint: "Email",
                  title: "Email",
                  colorTheme: colorTheme,
                ),
                Padding(
                  padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                ),
                PasswordTextField(
                  inputType: TextInputType.visiblePassword,
                  controller: _passwordEditingController,
                  hint: "Password",
                  title: "Password",
                  colorTheme: colorTheme,
                  validator: (String? value) {
                    if (PasswordValidator.get().isValid(value) ||
                        value == null ||
                        value.isEmpty) {
                      return null;
                    } else {
                      return "Weak password";
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                ),
                PasswordTextField(
                  inputType: TextInputType.visiblePassword,
                  key: _passwordConfirmKey,
                  controller: _passwordConfirmEditingController,
                  hint: "Confirm password",
                  title: "Confirm password",
                  colorTheme: colorTheme,
                  validator: (value) {
                    if (_passwordEditingController.text !=
                            _passwordConfirmEditingController.text &&
                        value != null &&
                        value.isNotEmpty) {
                      return "Passwords didn`t match";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
            Container(
              height: screenSize.height * 0.027,
            ),
            //Button column
            Column(
              children: [
                DefaultButton(
                    key: _buttonKey,
                    text: "Continue",
                    colorTheme: colorTheme,
                    onPressed: () {
                      if (_passwordEditingController.text ==
                          _passwordConfirmEditingController.text) {
                        FocusScope.of(context).unfocus();
                        /*ScreenNavigator.of(context: context)
                            .openEmailCheck(_emailController.text);*/
                      } else {
                        this._passwordConfirmKey.currentState?.validate();
                      }
                    }),
                Padding(padding: EdgeInsets.only(top: Sizes.standartMargin)),
                GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      text: '"Already have account" ',
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
                              color: colorTheme.primary),
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
    );
  }
}
