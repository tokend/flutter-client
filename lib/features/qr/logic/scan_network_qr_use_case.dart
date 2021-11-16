import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/config/logic/url_config_manager.dart';
import 'package:flutter_template/features/qr/view/qr_screen.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:get/get.dart';

class ScanNetworkQrUseCase extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    UrlConfigManager urlConfigManager =
        UrlConfigManager(urlConfigProvider, urlConfigPersistence);

    return Scaffold(
        body: BlocProvider(
      create: (_) => SignInBloc(env),
      child: ScanQRScreen((result, scannerContext) {
        var hasScanSucceed = urlConfigManager.setFromJson(result);
        scannerContext
            .read<SignInBloc>()
            .add(NetworkChanged(urlConfigProvider.getConfig().api));
        if (!hasScanSucceed) {
          toastManager.showShortToast('something_wrong_with_qr'.tr);
        }
      }),
    ));
  }
}
