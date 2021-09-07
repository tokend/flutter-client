import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';

class DefaultTextField extends StatefulWidget {
  final String title;
  final String hint;
  final BaseColorTheme colorTheme;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final bool showText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? textInputFormatters;
  final Color background;

  const DefaultTextField(
      {Key? key,
      this.background = Colors.transparent,
      this.textInputFormatters,
      this.title = "",
      this.controller,
      this.validator,
      required this.colorTheme,
      this.hint = "",
      this.inputType = TextInputType.text,
      this.suffixIcon,
      this.showText = true})
      : super(key: key);

  @override
  DefaultTextFieldState createState() => DefaultTextFieldState();
}

class DefaultTextFieldState extends State<DefaultTextField> {
  final _error = ValueNotifier<String?>(null);

  final _key = GlobalKey<FormState>();

  final _focusNode = FocusNode();

  var _textFieldText = "";

  void validate() {
    _error.value = widget.validator?.call(widget.controller?.text);
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _error.value = widget.validator?.call(widget.controller?.text);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _error.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Sizes.textSizeHint,
                  color: widget.colorTheme.primaryText),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Sizes.quartedStandartMargin)),
          ValueListenableBuilder(
              valueListenable: _error,
              builder: (context, String? value, child) {
                return TextFormField(
                  inputFormatters: widget.textInputFormatters,
                  keyboardType: widget.inputType,
                  focusNode: _focusNode,
                  onChanged: (text) {
                    if (_error.value != null && _textFieldText != text) {
                      _error.value = null;
                    }
                    _textFieldText = text;
                  },
                  controller: widget.controller,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: !widget.showText,
                  cursorColor: widget.colorTheme.primaryText,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Sizes.textSizeDialog,
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.background,
                      errorText: value,
                      errorBorder: _borderStyle(widget.colorTheme.negative),
                      focusedErrorBorder:
                          _borderStyle(widget.colorTheme.negative),
                      hintText: widget.hint,
                      isDense: true,
                      hintStyle: TextStyle(
                          color: widget.colorTheme.hint,
                          fontWeight: FontWeight.w400),
                      enabledBorder:
                          _borderStyle(widget.colorTheme.borderUnfocused),
                      focusedBorder: _borderStyle(widget.colorTheme.accent),
                      suffixIcon: widget.suffixIcon),
                );
              }),
        ],
      ),
    );
  }

  OutlineInputBorder _borderStyle(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: Sizes.borderWidth),
      borderRadius: BorderRadius.circular(Sizes.mediumRadius),
    );
  }
}
