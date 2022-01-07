import 'package:shared_preferences/shared_preferences.dart';

class SessionInfoStorage {
  final SharedPreferences sharedPreferences;

  SessionInfoStorage(this.sharedPreferences);

  static const LAST_SIGN_IN_METHOD_KEY = 'last_sign_in_method';

  void saveLastSignInMethod(String signInMethod) {
    sharedPreferences.setString(LAST_SIGN_IN_METHOD_KEY, signInMethod);
  }

  String? loadLastSignInMethod() {
    return sharedPreferences.getString(LAST_SIGN_IN_METHOD_KEY) ?? null;
  }

  void clear() {
    sharedPreferences.remove(LAST_SIGN_IN_METHOD_KEY);
  }
}
