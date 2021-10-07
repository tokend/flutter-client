import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class DefaultPhoneNumberField extends StatelessWidget {
  final String hint;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String label;
  final String? error;
  final ValueChanged<String> onChanged;
  final BaseColorTheme colorTheme;

  DefaultPhoneNumberField({
    this.hint = "",
    this.label = "",
    this.error,
    required this.controller,
    required this.formKey,
    required this.onChanged,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    // controller.text = "";
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Sizes.textSizeHint,
                color: colorTheme.accent),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: Sizes.quartedStandartMargin)),
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber value) {
            onChanged.call(value.phoneNumber!);
          },
          textFieldController: controller,
          ignoreBlank: true,
          autoValidateMode: AutovalidateMode.disabled,
          initialValue: PhoneNumber(isoCode: 'UA'),
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          inputDecoration: InputDecoration(
            filled: false,
            fillColor: Colors.transparent,
            errorText: error,
            errorBorder: _borderStyle(colorTheme.negative),
            focusedErrorBorder: _borderStyle(colorTheme.negative),
            hintText: hint,
            isDense: true,
            hintStyle:
                TextStyle(color: colorTheme.hint, fontWeight: FontWeight.w400),
            enabledBorder: _borderStyle(colorTheme.borderUnfocused),
            focusedBorder: _borderStyle(colorTheme.accent),
          ),
          selectorConfig: SelectorConfig(
            showFlags: false,
            setSelectorButtonAsPrefixIcon: true,
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _borderStyle(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: Sizes.borderWidth),
      borderRadius: BorderRadius.circular(Sizes.mediumRadius),
    );
  }
}
