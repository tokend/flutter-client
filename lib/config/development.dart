import 'package:flutter/material.dart';

import 'env.dart';

void main() => Development();

class Development extends Env {
  @override
  // String apiUrl = 'http://d631-193-19-228-94.ngrok.io/_/api/';
  String apiUrl = 'http://c663-193-19-228-94.ngrok.io/_/api/';

  @override
  String storageUrl =
      'https://s3.eu-west-1.amazonaws.com/demo-identity-storage-festive-colden/';

  @override
  Color primarySwatch = Color.fromARGB(100, 0, 150, 136);

  @override
  String appHost = 'demo.tokend.io';

  @override
  String clientUrl = 'https://demo.tokend.io/';

  @override
  int logoutTime = 0;
}
