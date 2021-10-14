import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_wallet/account.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_method.dart';
import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';
import 'package:flutter_template/logic/session.dart';
import 'package:get/get.dart';

class SignInUseCase {
  String _email;
  String _password;
  KeyServer _keyServer;
  Session _session;
  CredentialsPersistence? _credentialsPersistence;
  WalletInfoPersistence? _walletInfoPersistence;

  late WalletInfo _walletInfo;
  late Account _account;

  SignInUseCase(this._email, this._password, this._keyServer, this._session,
      this._credentialsPersistence, this._walletInfoPersistence);

  Future<void> perform() {
    return _getWalletInfo(_email, _password)
        .then((walletInfo) => this._walletInfo = walletInfo)
        .then((walletInfo) => _getAccountFromWalletInfo())
        .then((account) => this._account = account)
        .then((_) => _updateProviders());

    //TODO add postSignIn invoking
  }

  Future<WalletInfo> _getWalletInfo(String email, String password) async {
    var networkRequest = _keyServer.getWalletInfo(email, password);
    var result;
    try {
      result = _walletInfoPersistence?.loadWalletInfo(email, password);
      return Future.value(result);
    } catch (e) {
      return networkRequest;
    }
  }

  Future<Account> _getAccountFromWalletInfo() async {
    var account = await Account.fromSecretSeed(_walletInfo.secretSeeds.first);
    return account;
  }

  Future<bool> _updateProviders() async {
    try {
      _session.walletInfoProvider.setWalletInfo(_walletInfo);
      await _walletInfoPersistence?.saveWalletInfo(_walletInfo, _password);
      await _credentialsPersistence?.saveCredentials(
          _walletInfo.email, _password);
      _session.accountProvider.setAccount(_account);
      _session.signInMethod = SignInMethod.CREDENTIALS;
      Get.lazyPut(() => _session); //TODO refactor
      Get.lazyPut(() => _session.accountProvider);
      Get.lazyPut(() => _session.walletInfoProvider);
      return Future.value(true);
    } catch (e, s) {
      print(s);
      return Future.value(false);
    }
  }

//TODO performPostSignIn
}
