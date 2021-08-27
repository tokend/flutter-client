import 'package:flutter/widgets.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild());
  }

  //called after first build
  @protected
  void afterBuild() {}
}
