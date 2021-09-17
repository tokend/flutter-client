import 'package:flutter/material.dart';

import 'env.dart';

void main() => Development();

class Development extends Env {
  @override
  String apiUrl = 'https://api.staging.helpbees.de/';

  @override
  String storageUrl = 'https://s3.eu-west-1.amazonaws.com/demo-identity-storage-festive-colden/';

  @override
  Color primarySwatch = Color.fromARGB(100, 0, 150, 136);

  @override
  String appHost = 'demo.tokend.io';

  @override
  String clientUrl = 'https://demo.tokend.io/';

  @override
  int logoutTime = 0;
}
