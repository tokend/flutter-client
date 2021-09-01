import 'package:tuple/tuple.dart';

abstract class CredentialsProvider {
  Future<bool> hasCredentials();

  Future<Tuple2<String, String>> getCredentials();
}
