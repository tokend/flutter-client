import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';

class CounterTextField extends StatefulWidget {
  final String title;
  final String hint;
  final String label;
  final String defaultText;
  final String? error;
  final BaseColorTheme colorTheme;
  final TextInputType inputType;
  final String? suffixText;
  final Widget? suffixIcon;
  final bool showText;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter>? textInputFormatters;
  final Color background;
  final int? maxLines;
  final int? maxLength;

  const CounterTextField(
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
      this.maxLines,
      this.maxLength = 50,
      this.suffixText,
      this.suffixIcon,
      this.showText = true})
      : super(key: key);

  @override
  CounterTextFieldState createState() => CounterTextFieldState();
}

class CounterTextFieldState extends State<CounterTextField> {
  final _error = ValueNotifier<String?>(null);

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
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
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  initialValue: widget.defaultText,
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
                  //maxLength: 50,
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
                      counterText: widget.suffixText,
                      border: OutlineInputBorder(),
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
      borderRadius: BorderRadius.circular(Sizes.xSmallRadius),
    );
  }
}
