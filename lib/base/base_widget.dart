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
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseWidget {
  final ToastManager toastManager = Get.find();
  final RepositoryProviderImpl repositoryProvider = Get.find();
  final AppTfaCallback appTfaCallback = Get.find();
  final Env env = Get.find();
  final UrlConfigProvider urlConfigProvider = Get.find();
  final ObjectPersistence<UrlConfig> urlConfigPersistence = Get.find();
  final Session session = Get.find();
  final ErrorHandler errorHandler = Get.find();
  final TxManager txManager = Get.find();
  final SharedPreferences sharedPreferences = Get.find();
  final CredentialsPersistence credentialsPersistence = Get.find();
  final LocalAuthentication localAuthentication = Get.find();
}

abstract class BaseStatelessWidget extends StatelessWidget with BaseWidget {
  BaseStatelessWidget({Key? key}) : super(key: key);
}

abstract class BaseStatefulWidget extends StatefulWidget with BaseWidget {}
