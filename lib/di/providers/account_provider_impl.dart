import 'package:dart_wallet/account.dart';
import 'package:flutter_template/di/providers/account_provider.dart';

class AccountProviderImpl implements AccountProvider {
  Account? _account;

  @override
  Account? getAccount() => _account;

  @override
  void setAccount(Account? account) {
    this._account = account;
  }
}
