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

    return Card(
      color: isSelected ? colorScheme.accent : colorScheme.secondaryText,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color:
                isSelected ? colorScheme.accent : colorScheme.borderUnfocused,
            width: 1),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 11.0,
              color:
                  isSelected ? colorScheme.secondaryText : colorScheme.accent),
        ),
      ),
    );
  }
}
