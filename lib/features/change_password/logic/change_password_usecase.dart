import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/key_server/models/signer_data.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
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

  ChangePasswordUseCase(
      this._newPassword,
      this._apiProvider,
      this._accountProvider,
      this._walletInfoPersistence,
      this._repositoryProvider,
      this._credentialsPersistence,
      this._walletInfoProvider);

  late WalletInfo _currentWalletInfo;
  late Account _currentAccount;
  late Account _newAccount;
  int signerRole = 0;
  late List<SignerData> currentSigners;
  late NetworkParams _networkParams;
  late WalletInfo _newWalletInfo;

  Future<void> perform() {
    return getCurrentWalletInfo()
        .then((walletInfo) => this._currentWalletInfo = walletInfo)
        .then((_) => getCurrentAccount())
        .then((account) => this._currentAccount = account)
        .then((_) => generateNewAccount())
        .then((newAccount) => this._newAccount = newAccount)
        .then((_) async {
          _getDefaultSignerRole();
          //this.currentSigners = _getCurrentSigners();
          this._networkParams = await getNetworkParams();
        })
        .then((_) async => this._newWalletInfo = await _updateWallet())
        .then((_) async {
          return await _updateProviders();
        });
  }

  Future<WalletInfo> getCurrentWalletInfo() {
    var walletInfo = _walletInfoProvider.getWalletInfo();
    if (walletInfo == null) throw StateError('No wallet info found');
    return Future.value(walletInfo);
  }

  Account getCurrentAccount() {
    var account = _accountProvider.getAccount();
    if (account == null) throw StateError('No wallet info found');
    return account;
  }

  Future<Account> generateNewAccount() {
    return Account.random();
  }

  Future<int> _getDefaultSignerRole() {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null) throw StateError('No signed API instance found');

    return KeyServer.getDefaultSignerRole(signedApi.v3.keyValue);
  }

  List<SignerData> _getCurrentSigners() {
    List<SignerData> signersList = [];
    _apiProvider
        .getApi()
        .v3
        .signers
        .get(_currentWalletInfo.accountId)
        .then((signers) {
      return signers
          .forEach((key, value) => signersList.add(SignerData(key, value[0])));
    });

    return signersList;
  }

  Future<NetworkParams> getNetworkParams() {
    return _repositoryProvider.systemInfo
        .getItem()
        .then((systemInfoRecord) => systemInfoRecord.toNetworkParams());
  }

  Future<WalletInfo> _updateWallet() {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null) throw StateError('No signed API instance found');

    return KeyServer(signedApi.wallets).updateWalletPassword(
        _currentWalletInfo,
        _currentAccount,
        _newPassword,
        _newAccount,
        _networkParams,
        signedApi.v3.signers,
        signedApi.v3.keyValue);
  }

  _updateProviders() async {
    _walletInfoProvider.setWalletInfo(_newWalletInfo);
    _accountProvider.setAccount(_newAccount);

    // Update in persistent storage
    await _credentialsPersistence?.saveCredentials(
        _newWalletInfo.email, _newPassword);
    await _walletInfoPersistence?.saveWalletInfo(_newWalletInfo, _newPassword);
  }
}
