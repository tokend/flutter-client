import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';

/// Changes user's password:
/// updates wallet keychain data and account signers.
/// [accountProvider] and [walletInfoProvider] will be used to obtain
/// actual wallet info and will be updated with the new info on complete
class ChangePasswordUseCase {
  String _newPassword;
  ApiProvider _apiProvider;
  AccountProvider _accountProvider;
  WalletInfoProvider _walletInfoProvider;
  RepositoryProvider _repositoryProvider;
  CredentialsPersistence? _credentialsPersistence;
  WalletInfoPersistence? _walletInfoPersistence;

  ChangePasswordUseCase(this._newPassword, this._apiProvider,
      this._accountProvider, this._walletInfoPersistence,
      this._repositoryProvider,
      this._credentialsPersistence, this._walletInfoProvider);
}
