import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/api/wallets/model/exceptions.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/key_server/models/wallet_create_result.dart';
import 'package:dart_wallet/account.dart';

class SignUpUseCase {
  String _email;
  String _password;
  KeyServer _keyServer;
  TokenDApi _api;

  SignUpUseCase(this._email, this._password, this._keyServer, this._api);

  late Account _rootAccount;
  int _defaultSignerRole = 0;

  Future<WalletCreateResult> perform() async {
    var isFree = await _ensureEmailIsFree();
    _getAccount().then((rootAccount) => this._rootAccount = rootAccount);
    _getDefaultSignerRole().then(
        (defaultSignerRole) => this._defaultSignerRole = defaultSignerRole);
    return _createAndSaveWallet();
  }

  Future<bool> _ensureEmailIsFree() async {
    var isFree = false;
    _keyServer.getLoginParams(login: _email).onError((error, stackTrace) {
      if (error is InvalidCredentialsException) {
        isFree = true;
        return Future.error(error);
      } else {
        return Future.error(error!);
      }
    });
    return !isFree
        ? Future.error(EmailAlreadyTakenException())
        : Future.value(isFree);
  }

  Future<Account> _getAccount() {
    return Account.random();
  }

  Future<int> _getDefaultSignerRole() {
    return KeyServer.getDefaultSignerRole(_api.v3.keyValue);
  }

  Future<WalletCreateResult> _createAndSaveWallet() {
    return _keyServer.createAndSaveWalletWithDefaultSignerRole(
        _email, _password, _defaultSignerRole, _rootAccount);
  }
}
