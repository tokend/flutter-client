import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordToogle extends StatefulWidget {
  final Function(bool isShown) callback;

  final Color iconColor;

  const PasswordToogle({this.iconColor = Colors.black, required this.callback});

  @override
  _PasswordToogleState createState() => _PasswordToogleState();
}

class _PasswordToogleState extends State<PasswordToogle> {
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
