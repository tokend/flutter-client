import 'package:flutter_template/logic/credentials/credentials_provider.dart';
import 'package:tuple/tuple.dart';

abstract class CredentialsPersistence extends CredentialsProvider {
  /// @param email that is retrieved from corresponding WalletInfo
  /// @param password password for encryption
  void saveCredentials(String email, String password);

  /// @return saved email or null if it's missing
  String? getSavedEmail();

  /// @return true if there is a securely saved password
  bool hasSavedPassword();

  /// @return saved password or null if it's missing
  String? getSavedPassword();

  /// Clears stored credentials
  /// @param keepEmail if set then email will not be cleared
  /// @see getSavedEmail
  void clear(bool keepEmail);

  @override
  Tuple2<String, String> getCredentials() {
    return Tuple2(getSavedEmail()!, getSavedPassword()!);
  }

  @override
  bool hasCredentials() {
    return getSavedEmail() != null && hasSavedPassword();
  }
}
