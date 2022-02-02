import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';

class TimePeriodPicker extends StatelessWidget {
  String text;
  bool isSelected;

  TimePeriodPicker(this.text, this.isSelected);

  @override
  Widget build(BuildContext context) {
    var colorScheme = context.colorTheme;

    return Container(
      width: (MediaQuery.of(context).size.width - 32) / 4,
      child: Card(
        elevation: 0.0,
        color: isSelected ? colorScheme.primary : colorScheme.background,
        shape: RoundedRectangleBorder(
          side: isSelected
              ? BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.borderUnfocused,
                  width: isSelected ? 1 : 0)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
              color:
                  isSelected ? colorScheme.secondaryText : colorScheme.grayText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
