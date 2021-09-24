import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/qr/view/qr_screen.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_bloc.dart';
import 'package:flutter_template/config/logic/url_config_manager.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:get/get.dart';

class ScanNetworkQrUseCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Env env = Get.find();
    UrlConfigProvider urlConfigProvider = Get.find();
    ObjectPersistence<UrlConfig> urlConfigPersistence = Get.find();
    UrlConfigManager urlConfigManager =
    UrlConfigManager(urlConfigProvider, urlConfigPersistence);

    return Scaffold(
        body: BlocProvider(
          create: (_) => SignInBloc(env),
          child: ScanQRScreen((result, scannerContext) {
            urlConfigManager.setFromJson(result);
            scannerContext
                .read<SignInBloc>()
                .add(NetworkChanged(urlConfigProvider
                .getConfig()
                .api));
          }),
        ));
  }
}
