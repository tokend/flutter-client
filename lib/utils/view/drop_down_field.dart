import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/resources/theme/themes.dart';

class DropDownField<T> extends StatelessWidget {
  Function(String?) onChanged;
  T? currentValue;
  String labelText;
  String hintText;
  String? errorText;
  List<T> list;
  final BaseColorTheme colorTheme;
  final Color background;
  String Function(T) format;

  DropDownField({
    required this.onChanged,
    this.currentValue,
    this.labelText = "",
    this.hintText = "",
    this.errorText,
    required this.colorTheme,
    required this.list,
    this.background = Colors.transparent,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> formState) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  labelText,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Sizes.textSizeHint,
                      color: colorTheme.accent),
                ),
              ),
            ),
            InputDecorator(
              decoration: InputDecoration(
                filled: false,
                fillColor: background,
                errorText: errorText,
                errorBorder: _borderStyle(colorTheme.negative),
                focusedErrorBorder: _borderStyle(colorTheme.negative),
                isDense: true,
                hintStyle: TextStyle(
                    color: colorTheme.hint, fontWeight: FontWeight.w400),
                enabledBorder: _borderStyle(colorTheme.borderUnfocused),
                focusedBorder: _borderStyle(colorTheme.accent),
              ),
              isEmpty: false,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  //TODO change dropdown icon
                  value: currentValue == "" ? list.first : currentValue,
                  isDense: true,
                  onChanged: (newValue) {
                    onChanged.call(newValue.toString());
                  },
                  hint: Container(
                    alignment: Alignment.centerLeft,
                    width: 150, //and here
                    child: Text(
                      hintText,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  items: list.map((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(format.call(value)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _borderStyle(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: Sizes.borderWidth),
      borderRadius: BorderRadius.circular(Sizes.xSmallRadius),
    );
  }
}

class BalanceDropDownField extends StatelessWidget {
  Function(BalanceRecord?) onChanged;
  BalanceRecord? currentValue;
  String labelText;
  String hintText;
  String? errorText;
  List<BalanceRecord> list;
  final BaseColorTheme colorTheme;
  final Color background;

  BalanceDropDownField(
      {required this.onChanged,
      this.currentValue,
      this.labelText = "",
      this.hintText = "",
      this.errorText,
      required this.colorTheme,
      this.background = Colors.transparent,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> formState) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  labelText,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Sizes.textSizeHint,
                      color: colorTheme.accent),
                ),
              ),
            ),
            InputDecorator(
              decoration: InputDecoration(
                filled: false,
                fillColor: background,
                errorText: errorText,
                errorBorder: _borderStyle(colorTheme.negative),
                focusedErrorBorder: _borderStyle(colorTheme.negative),
                isDense: true,
                hintStyle: TextStyle(
                    color: colorTheme.hint, fontWeight: FontWeight.w400),
                enabledBorder: _borderStyle(colorTheme.borderUnfocused),
                focusedBorder: _borderStyle(colorTheme.accent),
              ),
              isEmpty: false,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  //TODO change dropdown icon
                  value: currentValue == null ? list.first : currentValue,
                  isDense: true,
                  onChanged: (newValue) {
                    onChanged.call(newValue as BalanceRecord);
                  },
                  hint: Container(
                    alignment: Alignment.centerLeft,
                    width: 150, //and here
                    child: Text(
                      hintText,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  items: list.map((BalanceRecord value) {
                    return DropdownMenuItem<BalanceRecord>(
                      value: value,
                      child: Text(
                          '${value.asset.name} (${value.available} ${value.asset.code})'),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _borderStyle(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: Sizes.borderWidth),
      borderRadius: BorderRadius.circular(Sizes.xSmallRadius),
    );
  }
}
