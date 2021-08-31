import 'dart:typed_data';

import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class CredentialsPersistenceImpl implements CredentialsPersistence {
  final SharedPreferences _sharedPreferences;

  CredentialsPersistenceImpl(this._sharedPreferences) {
    this._secureStorage = SecureStorage(_sharedPreferences);
  }

  late SecureStorage _secureStorage;

  @override
  void clear(bool keepEmail) {
    _secureStorage.clear(PASSWORD_KEY);
    if (!keepEmail) {
      _sharedPreferences.remove(EMAIL_KEY);
    }
  }

  @override
  String? getSavedEmail() {
    return _sharedPreferences.getString(EMAIL_KEY) != null
        ? _sharedPreferences.getString(EMAIL_KEY)
        : null;
  }

  @override
  String? getSavedPassword() {
    var passwordBytes = _secureStorage.load(PASSWORD_KEY);
    if (passwordBytes == null) return null;
    var password = String.fromCharCodes(passwordBytes);
  }

  @override
  bool hasSavedPassword() {
    var password = getSavedPassword();
    var hasPassword = password != null;
    password = '';
    return hasPassword;
  }

  @override
  void saveCredentials(String email, String password) {
    _tryToSavePassword(password);
    _sharedPreferences.setString(EMAIL_KEY, email);
  }

  void _tryToSavePassword(String password) {
    var passwordBytes = Uint8List.fromList(password.codeUnits);
    _secureStorage.save(passwordBytes, PASSWORD_KEY);
  }

  static const PASSWORD_KEY = '(¬_¬)';
  static const EMAIL_KEY = 'email';

  @override
  Tuple2<String, String> getCredentials() {
    return this.getCredentials();
  }

  @override
  bool hasCredentials() {
    return this.hasCredentials();
  }
}
