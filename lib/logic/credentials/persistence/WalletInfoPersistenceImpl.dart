import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:flutter_template/logic/credentials/persistence/wallet_info_persistence.dart';
import 'package:flutter_template/storage/persistence/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletInfoPersistenceImpl implements WalletInfoPersistence {
  final SharedPreferences _sharedPreferences;

  WalletInfoPersistenceImpl(this._sharedPreferences) {
    this._secureStorage = SecureStorage(_sharedPreferences);
  }

  late SecureStorage _secureStorage;

  @override
  void clear() {
    _secureStorage.clear(SEED_KEY);
    _secureStorage.clear(WALLET_INFO_KEY);
  }

  @override
  WalletInfo? loadWalletInfo(String email, String password) {
    try {
      var walletInfoBytes =
          _secureStorage.loadWithPassword(WALLET_INFO_KEY, password);
      if (walletInfoBytes == null) return null;
      var walletInfo = WalletInfo.fromJson(
          jsonDecode(String.fromCharCodes(walletInfoBytes)));
      walletInfo.accountId.length; // Will fall with NPE on failed parsing.
      var seedBytes = _secureStorage.loadWithPassword(SEED_KEY, password);
      if (seedBytes == null) return null;
      walletInfo.setSecretSeed = String.fromCharCodes(seedBytes);
      return email == walletInfo.email ? walletInfo : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void saveWalletInfo(WalletInfo data, String password) {
    var copyWalletInfo = WalletInfo(
        data.accountId, data.email, data.walletIdHex, data.loginParams, ['']);
    var nonSensitiveData =
        Uint8List.fromList(copyWalletInfo.toJson().toString().codeUnits);
    var sensitiveData = Uint8List.fromList(data.secretSeeds.first.codeUnits);
    _secureStorage.saveWithPassword(sensitiveData, SEED_KEY, password);
    _secureStorage.saveWithPassword(
        nonSensitiveData, WALLET_INFO_KEY, password);
  }

  static const SEED_KEY = '(◕‿◕✿)';
  static const WALLET_INFO_KEY = 'ಠ_ಠ';
}
