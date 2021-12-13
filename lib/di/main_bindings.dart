import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/config/providers/url_config_provider_impl.dart';
import 'package:flutter_template/config/stotrage/url_config_persistence.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/account_provider_impl.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/api_provider_impl.dart';
import 'package:flutter_template/di/providers/repository_provider_impl.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider_impl.dart';
import 'package:flutter_template/features/tfa%20/app_tfa_callback.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence_impl.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence_impl.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:flutter_template/utils/error_handler/default_error_handler.dart';
import 'package:flutter_template/utils/error_handler/error_handler.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBindings extends Bindings {
  Env env;
  SharedPreferences sharedPreferences;

  MainBindings(this.env, this.sharedPreferences);

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
    ApiProvider apiProvider =
        ApiProviderImpl(urlConfigProvider, tfaCallback, env.withLogs);
    Session session = Session(walletInfoProvider, accountProvider);
    ObjectPersistence<UrlConfig> urlConfigPersistence =
        UrlConfigPersistence(sharedPreferences);
    CredentialsPersistence credentialsPersistence =
        CredentialsPersistenceImpl(sharedPreferences);
    WalletInfoPersistence walletInfoPersistence =
        WalletInfoPersistenceImpl(sharedPreferences);
    TxManager txManager = TxManager(apiProvider);
    RepositoryProviderImpl repositoryProvider = RepositoryProviderImpl(
        apiProvider: apiProvider,
        walletInfoProvider: walletInfoProvider,
        urlConfigProvider: urlConfigProvider,
        persistencePreferences: sharedPreferences);
    ToastManager toastManager = ToastManager();
    ErrorHandler errorHandler = DefaultErrorHandler(toastManager);

    //Put to GetX pool
    Get.put(env);
    Get.put(tfaCallback);
    Get.put(apiProvider);
    Get.put(urlConfigProvider);
    Get.put(session);
    Get.put(sharedPreferences);
    Get.put(urlConfigPersistence);
    Get.put(credentialsPersistence);
    Get.put(walletInfoPersistence);
    Get.put(walletInfoProvider);
    Get.lazyPut(() => txManager);
    Get.put(repositoryProvider);
    Get.put(toastManager);
    Get.put(errorHandler);
    //TODO: add dependencies, example: https://pub.dev/packages/get/example
  }
}
