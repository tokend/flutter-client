import 'package:tuple/tuple.dart';

abstract class CredentialsProvider {
  bool hasCredentials();

  Tuple2<String, String> getCredentials();
}
