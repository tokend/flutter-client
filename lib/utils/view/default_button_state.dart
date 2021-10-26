import 'package:flutter/material.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';

class DefaultButton extends StatefulWidget {
  final BaseColorTheme colorTheme;
  final String text;
  final Function onPressed;
  final bool defaultState;

  DefaultButton(
      {Key? key,
      required this.colorTheme,
      required this.onPressed,
      required this.text,
      this.defaultState = false})
      : super(key: key);

  @override
  DefaultButtonState createState() =>
      DefaultButtonState(defaultState: defaultState);
}

class DefaultButtonState extends State<DefaultButton> {
  bool defaultState;
  var _isButtonEnabled = ValueNotifier(true);

  DefaultButtonState({this.defaultState = true}) {
    _isButtonEnabled = ValueNotifier(defaultState);
  }

  bool getIsEnabled() {
    return _isButtonEnabled.value;
  }

  void setIsEnabled(bool value) {
    _isButtonEnabled.value = value;
  }

  @override
  void dispose() {
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isButtonEnabled,
      builder: (context, bool value, child) {
        return ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 56)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.xSmallRadius),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(value
                ? widget.colorTheme.primary
                : widget.colorTheme.buttonDisabled),
          ),
          onPressed: value
              ? () {
                  widget.onPressed();
                }
              : null,
          child: Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Sizes.textSizeDialog,
                color: widget.colorTheme.secondaryText),
          ),
        );
      },
    );
  }
}
