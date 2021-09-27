import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/di/main_bindings.dart';
import 'package:flutter_template/features/kyc/view/kyc_scaffold.dart';
import 'package:flutter_template/features/qr/logic/scan_network_qr_use_case.dart';
import 'package:flutter_template/features/recovery/view/recovery_scaffold.dart';
import 'package:flutter_template/features/sign_in/view/sign_in_scaffold.dart';
import 'package:flutter_template/features/sign_up/view/sign_up_scaffold.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

List<GetPage<dynamic>> getPageList(Env env) => [
      GetPage(
          name: '/signIn',
          page: () => SignInScaffold(),
          binding: MainBindings(env)),
      GetPage(
          name: '/signUp',
          page: () => SignUpScaffold(),
          binding: MainBindings(env)),
      GetPage(
          name: '/kycForm',
          page: () => KycScaffold(),
          binding: MainBindings(env)),
      GetPage(
          name: '/qr',
          page: () => ScanNetworkQrUseCase(),
          binding: MainBindings(env)),
      GetPage(
          name: '/recovery',
          page: () => RecoveryScaffold(),
          binding: MainBindings(env)),
    ];
