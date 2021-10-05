import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';
import 'package:get/get.dart';

class DefaultTextField extends StatefulWidget {
  final String title;
  final String hint;
  final String label;
  final String defaultText;
  final String? error;
  final BaseColorTheme colorTheme;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final bool showText;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter>? textInputFormatters;
  final Color background;

  const DefaultTextField(
      {Key? key,
      this.background = Colors.transparent,
      this.textInputFormatters,
      this.title = "",
      this.error,
      required this.onChanged,
      required this.colorTheme,
      this.hint = "",
      this.label = "",
      this.defaultText = "",
      this.inputType = TextInputType.text,
      this.suffixIcon,
      this.showText = true})
      : super(key: key);

  @override
  DefaultTextFieldState createState() => DefaultTextFieldState();
}

class DefaultTextFieldState extends State<DefaultTextField> {
  Env env = Get.find();
  final _error = ValueNotifier<String?>(null);

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _error.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // controller.addListener(() { controller.text});
    return Form(
      key: _key,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Sizes.textSizeHint,
                  color: widget.colorTheme.accent),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Sizes.quartedStandartMargin)),
          ValueListenableBuilder(
              valueListenable: _error,
              builder: (context, String? value, child) {
                return TextFormField(
                  /*decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixText: '${textLength.toString()}/${maxLength.toString()}',
                    counterText: "",
                  ),         */         initialValue: widget.defaultText,
                  inputFormatters: widget.textInputFormatters,
                  keyboardType: widget.inputType,
                  onChanged: widget.onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: !widget.showText,
                  cursorColor: widget.colorTheme.primaryText,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Sizes.textSizeDialog,
                  ),
                  decoration: InputDecoration(
                      filled: false,
                      fillColor: widget.background,
                      errorText: widget.error,
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
