import 'package:flutter/material.dart';

import 'env.dart';

void main() => Production();

class Production extends Env {
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
}
