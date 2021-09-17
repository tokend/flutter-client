import 'dart:developer';

import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/di/providers/account_provider_impl.dart';
import 'package:flutter_template/di/providers/wallet_info_provider_impl.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_usecase.dart';
import 'package:flutter_template/features/sign_in/view/default_button.dart';
import 'package:flutter_template/features/sign_in/view/default_text_field.dart';
import 'package:flutter_template/features/sign_in/view/password_text_field.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence_impl.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence_impl.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/validators/email_validator.dart';
import 'package:flutter_template/utils/view/base_state.dart';
import 'package:flutter_template/view/templates/sign_in_template.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInCreateState createState() => _SignInCreateState();
}

class _SignInCreateState extends BaseState<SignInScreen> {
  final _emailController = TextEditingController();

  final _passwordEditingController = TextEditingController();

  final _buttonKey = GlobalKey<DefaultButtonState>();

  final Env env = Get.find();

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;

    log('STORAGE ENV ${env.apiUrl}');
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
                    'titleSignIn'.tr,
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
                    if (EmailValidator.get().isValid(value) || value!.isEmpty) {
                      return null;
                    } else {
                      return 'errorInvalidEmail'.tr;
                    }
                  },
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  hint: 'email'.tr,
                  title: 'email'.tr,
                  colorTheme: colorTheme,
                ),
                Padding(
                  padding: EdgeInsets.only(top: Sizes.halfStandartPadding),
                ),
                PasswordTextField(
                  inputType: TextInputType.visiblePassword,
                  controller: _passwordEditingController,
                  hint: 'password'.tr,
                  title: 'enterPasswordTitle'.tr,
                  colorTheme: colorTheme,
                ),
                Padding(
                  padding: EdgeInsets.only(top: Sizes.quartedStandartPadding),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        text: '${'forgotPassword'.tr} ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.textSizeHint,
                            color: colorTheme.hint),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'recoverAction'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Sizes.textSizeHint,
                                color: colorTheme.primary),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {
                      Get.toNamed('/signIn')
                      //ScreenNavigator.of(context: context).openRecoveryScreen()
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: screenSize.height * 0.1,
            ),
            //Button column
            Column(
              children: [
                DefaultButton(
                    key: _buttonKey,
                    text: 'loginAction'.tr,
                    colorTheme: colorTheme,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await onLoginClick();
                      Navigator.pop(context);
                    }),
                Padding(padding: EdgeInsets.only(top: Sizes.standartMargin)),
                GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      text: '${'dontHaveAccount'.tr} ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.textSizeHint,
                          color: colorTheme.hint),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'registerAction'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.textSizeHint,
                              color: colorTheme.primary),
                        ),
                      ],
                    ),
                  ),
                  onTap: onLoginClick,
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

  void _showToast() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('HI THERE'),
        // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<void> onLoginClick() async {
    var prefs = await SharedPreferences.getInstance();
    var tokendApi = TokenDApi(env.apiUrl);
    await SignInUseCase(
            'testuser@gmail.com',
            //_emailController.text,
            'testuser@gmail.com',
            //_passwordEditingController.text,
            KeyServer(tokendApi.wallets),
            Session(WalletInfoProviderImpl(), AccountProviderImpl()),
            CredentialsPersistenceImpl(prefs),
            WalletInfoPersistenceImpl(prefs))
        .perform()
        .then((value) => _showToast());
    //.whenComplete(() => _showToast()).onError((error, stackTrace) => print(error));
    //_showToast();
    // Get.toNamed('/signIn');
  }
}
