import 'package:flutter/material.dart';
import 'package:flutter_template/resources/theme/themes.dart';
import 'package:flutter_template/utils/view/password_toggle.dart';

import 'default_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final String title;
  final String hint;
  final String label;
  final String? error;
  final BaseColorTheme colorTheme;
  final Color? backgroundColor;
  final TextInputType inputType;
  final ValueChanged<String> onChanged;

  const PasswordTextField(
      {Key? key,
      this.title = "",
      required this.onChanged,
      required this.colorTheme,
      this.backgroundColor,
      this.error,
      this.hint = "",
      this.label = "",
      this.inputType = TextInputType.text})
      : super(key: key);

  @override
  PasswordTextFieldState createState() {
    return PasswordTextFieldState();
  }
}

class PasswordTextFieldState extends State<PasswordTextField> {
  var _isPasswordVisible = false;

  final _textFieldKey = GlobalKey<DefaultTextFieldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      background: widget.backgroundColor ?? Colors.white,
      key: _textFieldKey,
      showText: _isPasswordVisible,
      title: widget.title,
      onChanged: widget.onChanged,
      colorTheme: widget.colorTheme,
      hint: widget.hint,
      label: widget.label,
      error: widget.error,
      inputType: widget.inputType,
      suffixIcon: PasswordToggle(
        iconColor: widget.colorTheme.suffixIcons,
        callback: (isShown) => this.setState(() {
          _isPasswordVisible = isShown;
        }),
      ),
    );
  }
}
