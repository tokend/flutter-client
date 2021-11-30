import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class Development extends Env {
  SharedPreferences sp;
  @override
  String apiUrl = 'http://3268-193-19-228-94.ngrok.io/_/api/';

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

  @override
  SharedPreferences sharedPreferences;

  Development(this.sp) : sharedPreferences = sp;
}
