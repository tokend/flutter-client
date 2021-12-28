import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/assets/view/assets_screen.dart';
import 'package:flutter_template/features/balances/view/balances_screen.dart';
import 'package:flutter_template/features/change_password/view/change_password_screen.dart';
import 'package:flutter_template/features/home/view/home_screen.dart';
import 'package:flutter_template/features/kyc/view/kyc_scaffold.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/recovery/view/recovery_scaffold.dart';
import 'package:flutter_template/features/settings/view/security/account_id/account_id_screen.dart';
import 'package:flutter_template/features/settings/view/security/network_screen/network_screen.dart';
import 'package:flutter_template/features/settings/view/security/secret_seed/secret_seed_screen.dart';
import 'package:flutter_template/features/settings/view/settings_screen.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:flutter_template/features/unlock/view/unlock_app_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<GetPage<dynamic>> getPageList(
        Env env, SharedPreferences sharedPreferences, MainBindings binding) =>
    [
      GetPage(
          name: '/signIn',
          page: () => SignInScaffold(),
          binding: MainBindings(env, sharedPreferences)),
      GetPage(
          name: '/signUp',
          page: () => SignUpScaffold(),
          binding: MainBindings(env, sharedPreferences)),
      GetPage(
          name: '/kycForm',
          page: () => KycScaffold(),
          binding: MainBindings(env, sharedPreferences)),
      GetPage(
          name: '/qr',
          page: () => ScanNetworkQrUseCase(),
          binding: MainBindings(env, sharedPreferences)),
      GetPage(
          name: '/recovery',
          page: () => RecoveryScaffold(),
          binding: MainBindings(env, sharedPreferences)),
      GetPage(name: '/home', page: () => HomeScreen(), binding: binding),
      GetPage(
          name: '/balances',
          page: () => BalancesScreen(false, false),
          binding: binding),
      GetPage(
          name: '/unlock', page: () => UnlockAppScaffold(), binding: binding),
      GetPage(
          name: '/settings', page: () => SettingsScreen(), binding: binding),
      GetPage(
          name: '/changePassword',
          page: () => ChangePasswordScaffold(),
          binding: binding),
      GetPage(
          name: '/accountId', page: () => AccountIdScreen(), binding: binding),
      GetPage(
          name: '/secretSeed',
          page: () => SecretSeedScreen(),
          binding: binding),
      GetPage(
          name: '/passphraseScreen',
          page: () => PassphraseScreen(),
          binding: binding),
      GetPage(
          name: '/assetsScreen', page: () => AssetsScreen(), binding: binding),
    ];
