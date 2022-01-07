import 'package:dart_sdk/key_server/models/wallet_info.dart';

abstract class WalletInfoProvider {
  void setWalletInfo(WalletInfo? walletInfo);

  WalletInfo? getWalletInfo();
}
