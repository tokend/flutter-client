import 'package:dart_wallet/account.dart';

abstract class AccountProvider {
  void setAccount(Account? account);

  Account? getAccount();
}
