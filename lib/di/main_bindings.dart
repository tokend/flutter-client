import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/config/providers/url_config_provider_impl.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/account_provider_impl.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/api_provider_impl.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider_impl.dart';
import 'package:flutter_template/features/tfa%20/app_tfa_callback.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence_impl.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence_impl.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBindings extends Bindings {
  Env env;

  MainBindings(this.env);

  @override
  void dependencies() {
    //Initialize dependencies
    WalletInfoProvider walletInfoProvider = WalletInfoProviderImpl();
    AccountProvider accountProvider = AccountProviderImpl();
    UrlConfig defaultUrlConfig =
        UrlConfig(env.apiUrl, env.storageUrl, env.clientUrl, env.withLogs);
    UrlConfigProvider urlConfigProvider = UrlConfigProviderImpl()
      ..setConfig(defaultUrlConfig);
    AppTfaCallback tfaCallback = AppTfaCallback();
    ApiProvider apiProvider = ApiProviderImpl(urlConfigProvider,
        accountProvider, walletInfoProvider, tfaCallback, env.withLogs);
    Session session = Session(walletInfoProvider, accountProvider);
    Future<SharedPreferences> sharedPreferences =
    SharedPreferences.getInstance();
    CredentialsPersistence credentialsPersistence =
        CredentialsPersistenceImpl(sharedPreferences);
    WalletInfoPersistence walletInfoPersistence =
        WalletInfoPersistenceImpl(sharedPreferences);

    //Put to GetX pool
    Get.put(env);
    Get.put(apiProvider);
    Get.put(urlConfigProvider);
    Get.put(session);
    Get.put(credentialsPersistence);
    Get.put(walletInfoPersistence);
    //TODO: add dependencies, example: https://pub.dev/packages/get/example
  }
}
