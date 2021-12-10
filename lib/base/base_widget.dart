import 'package:flutter/cupertino.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/config/model/url_config.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/di/providers/repository_provider_impl.dart';
import 'package:flutter_template/features/tfa%20/app_tfa_callback.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:flutter_template/utils/error_handler/error_handler.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseWidget {
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
}

abstract class BaseStatelessWidget extends StatelessWidget with BaseWidget {
  BaseStatelessWidget({Key? key}): super(key: key);
}

abstract class BaseStatefulWidget extends StatefulWidget with BaseWidget {}
