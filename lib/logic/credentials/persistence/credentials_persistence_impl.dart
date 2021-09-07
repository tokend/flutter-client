import 'package:flutter_template/logic/credentials/persistence/credentials_persistence.dart';
import 'package:flutter_template/storage/persistence/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsPersistenceImpl extends CredentialsPersistence {
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
  Future<String?> getSavedPassword() async {
    var password = await _secureStorage.load(PASSWORD_KEY);
    if (password == null) return null;
    return password;
  }

  @override
  Future<bool> hasSavedPassword() async {
    var password = await getSavedPassword();
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
    _secureStorage.save(password, PASSWORD_KEY);
  }

  static const PASSWORD_KEY = '(¬_¬)';
  static const EMAIL_KEY = 'email';

}