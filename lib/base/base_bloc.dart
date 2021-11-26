import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart' as repo;
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  ApiProvider apiProvider = Get.find();
  Session session = Get.find();
  WalletInfoPersistence walletInfoPersistence = Get.find();
  WalletInfoProvider walletInfoProvider = Get.find();
  CredentialsPersistence credentialsPersistence = Get.find();
  ToastManager toastManager = Get.find();
  repo.RepositoryProvider repositoryProvider = Get.find();
}
