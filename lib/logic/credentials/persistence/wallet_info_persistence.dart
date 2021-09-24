import 'package:dart_sdk/key_server/models/wallet_info.dart';

abstract class WalletInfoPersistence {
  /// [data] with filled [WalletInfo.secretSeed] field.
  /// [password] for encryption
  Future<void> saveWalletInfo(WalletInfo data, String password);

  Future<WalletInfo?> loadWalletInfo(String email, String password);

  /// See loadWalletInfo
  Future<WalletInfo?> loadFutureWalletInfo(String email, String password) {
    var res = loadWalletInfo(email, password);
    if (res != null)
      return res;
    else
      return Future.value();
  }

  /// Clears stored data
  void clear();
}
