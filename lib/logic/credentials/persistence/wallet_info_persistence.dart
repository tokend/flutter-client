import 'package:dart_sdk/key_server/models/wallet_info.dart';

abstract class WalletInfoPersistence {
  void saveWalletInfo(WalletInfo data, String password);

  WalletInfo? loadWalletInfo(String email, String password);

  //TODO: implement loadWalletInfoMaybe if needed

  void clear();
}
