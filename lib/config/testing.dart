import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';


class Testing extends Env {
  SharedPreferences sp;

  @override
  String apiUrl = 'https://api.demo.tokend.io';

  @override
  String storageUrl = '';

  @override
  Color primarySwatch = Color.fromARGB(100, 0, 150, 136);

  @override
  String appHost = '';

  @override
  String clientUrl = '';

  @override
  int logoutTime = 0;

  @override
  SharedPreferences sharedPreferences;

  Testing(this.sp) : sharedPreferences = sp;
}
