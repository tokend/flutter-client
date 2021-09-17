import 'package:flutter/material.dart';
import 'package:flutter_template/features/sign_in/view/default_text_field.dart';
import 'package:flutter_template/features/sign_in/view/password_toggle.dart';
import 'package:flutter_template/resources/theme/themes.dart';

class PasswordTextField extends StatefulWidget {
  final String title;
  final String hint;
  final BaseColorTheme colorTheme;
  final TextInputType inputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const PasswordTextField(
      {Key? key,
      this.title = "",
      this.controller,
      this.validator,
      required this.colorTheme,
      this.hint = "",
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

  void validate() {
    _textFieldKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      key: _textFieldKey,
      showText: _isPasswordVisible,
      title: widget.title,
      controller: widget.controller,
      validator: widget.validator,
      colorTheme: widget.colorTheme,
      hint: widget.hint,
      inputType: widget.inputType,
      suffixIcon: PasswordToogle(
        iconColor: widget.colorTheme.suffixIcons,
        callback: (isShown) => this.setState(() {
          _isPasswordVisible = isShown;
        }),
      ),
    );
  }
}
