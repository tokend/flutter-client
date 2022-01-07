import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';

abstract class ApiProvider {
  TokenDApi getApi();

  TokenDApi getSignedApi();

  KeyServer getKeyServer();

  KeyServer? getSignedKeyServer();
}
