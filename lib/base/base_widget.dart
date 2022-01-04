import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/di/providers/repository_provider_impl.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/tfa%20/logic/app_tfa_callback.dart';
import 'package:flutter_template/features/tfa%20/view/tfa_dialog_factory.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:flutter_template/utils/error_handler/error_handler.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseWidget implements TfaCallback {
  ToastManager toastManager = Get.find();
  RepositoryProviderImpl repositoryProvider = Get.find();
  AppTfaCallback appTfaCallback = Get.find();
  Env env = Get.find();
  UrlConfigProvider urlConfigProvider = Get.find();
  ObjectPersistence<UrlConfig> urlConfigPersistence = Get.find();
  Session session = Get.find();
  ErrorHandler errorHandler = Get.find();
  TxManager txManager = Get.find();
  SharedPreferences sharedPreferences = Get.find();
  CredentialsPersistence credentialsPersistence = Get.find();
  LocalAuthentication localAuthentication = Get.find();
  WalletInfoProvider walletInfoProvider = Get.find();

  @override
  Future<void> onTfaRequired(NeedTfaException exception,
      TfaVerifierInterface verifierInterface) async {
    var login = session.walletInfoProvider.getWalletInfo()?.email;

    TfaDialogFactory()
        .getForException(exception, verifierInterface, login: login)
        .show();
  }
}

abstract class BaseStatelessWidget extends StatelessWidget with BaseWidget {
  BaseStatelessWidget({Key? key}) : super(key: key) {
    appTfaCallback.registerHandler(this);
  }
}

abstract class BaseStatefulWidget extends StatefulWidget with BaseWidget {
  BaseStatefulWidget({Key? key}) : super(key: key) {
    appTfaCallback.registerHandler(this);
  }
}
