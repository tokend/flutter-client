import 'package:flutter/material.dart';

class PasswordToggle extends StatefulWidget {
  final Function(bool isShown) callback;

  final Color iconColor;

  const PasswordToggle({this.iconColor = Colors.black, required this.callback});

  @override
  _PasswordToggleState createState() => _PasswordToggleState();
}

class _PasswordToggleState extends State<PasswordToggle> {
  var _isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPasswordShown ? Icons.visibility_off : Icons.visibility,
        color: widget.iconColor,
      ),
      onPressed: () {
        setState(() => this._isPasswordShown = !this._isPasswordShown);
        widget.callback(this._isPasswordShown);
      },
    );
  }
}
