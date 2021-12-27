import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/resources/sizes.dart';

class OfferTypePickerItem extends StatelessWidget {
  String text;
  bool isSelected;

  OfferTypePickerItem(this.text, this.isSelected);

  @override
  Widget build(BuildContext context) {
    var colorScheme = context.colorTheme;

    return Container(
      width: (MediaQuery.of(context).size.width / 2) -
          Sizes.standartPadding -
          Sizes.halfStandartMargin,
      child: Card(
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
                color: isSelected
                    ? colorScheme.secondaryText
                    : colorScheme.accent),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
