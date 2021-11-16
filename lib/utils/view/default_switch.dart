import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DefaultSwitch extends StatefulWidget {
  @override
  State<DefaultSwitch> createState() => _DefaultSwitchState();
}

class _DefaultSwitchState extends State<DefaultSwitch> {
  bool isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(value: isSwitchOn, onToggle: (value) =>
        setState(() {
          isSwitchOn = value;
        }));
  }
}