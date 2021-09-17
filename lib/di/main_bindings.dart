import 'package:flutter_template/config/env.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class MainBindings extends Bindings {
  Env env;

  MainBindings(this.env);

  @override
  void dependencies() {
    Get.put(env);
    // TODO: add dependencies, example: https://pub.dev/packages/get/example
  }
}
