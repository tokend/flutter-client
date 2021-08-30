import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';

class WalletInfoProviderImpl implements WalletInfoProvider {
  WalletInfo? _walletInfo;

  @override
  WalletInfo? getWalletInfo() => _walletInfo;

  @override
  void setWalletInfo(WalletInfo? walletInfo) {
    this._walletInfo = walletInfo;
  }
}
