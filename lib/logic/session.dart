import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/sign_in/logic/sign_in_method.dart';
import 'package:flutter_template/logic/persistence/session_info_storage.dart';

/// Holds session data
class Session {
  WalletInfoProvider walletInfoProvider;
  AccountProvider accountProvider;
  final SessionInfoStorage? sessionInfoStorage;

  Session(this.walletInfoProvider, this.accountProvider,
      {this.sessionInfoStorage});

  /// @returns true if session is expired and so sign out is required
  bool isExpired = false;

  /// @returns [SignInMethod] used to start this session
  String? _signInMethod;

  set signInMethod(String? value) {
    _signInMethod = value;
    if (value != null) {
      sessionInfoStorage?.saveLastSignInMethod(value);
    }
  }

  /// @returns last used [SignInMethod]
  String? get lastSignInMethod {
    return sessionInfoStorage?.loadLastSignInMethod();
  }

  /// @returns true if session was started with [LocalAccount] sign in
  bool get isLocalAccountUsed {
    return _signInMethod == SignInMethod.LOCAL_ACCOUNT;
  }

  /// Resets the session to the initial state, clears data
  void reset() {
    isExpired = false;
    signInMethod = null;

    walletInfoProvider.setWalletInfo(null);
    accountProvider.setAccount(null);
  }
}
