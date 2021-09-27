import 'package:flutter_template/logic/credentials/credentials_provider.dart';
import 'package:tuple/tuple.dart';

abstract class CredentialsPersistence extends CredentialsProvider {
  /// @param email that is retrieved from corresponding WalletInfo
  /// @param password password for encryption
  void saveCredentials(String email, String password);

  /// @return saved email or null if it's missing
  String? getSavedEmail();

  /// @return true if there is a securely saved password
  Future<bool> hasSavedPassword();

  /// @return saved password or null if it's missing
  Future<String?> getSavedPassword();

  /// Clears stored credentials
  /// @param keepEmail if set then email will not be cleared
  /// @see getSavedEmail
  void clear(bool keepEmail);

  @override
  Future<Tuple2<String, String>> getCredentials() async {
    var password = await getSavedPassword();
    var email = await getSavedEmail();
    return Tuple2(email!, password!);
  }

  @override
  Future<bool> hasCredentials() async {
    return getSavedEmail() != null && await hasSavedPassword();
  }
}
