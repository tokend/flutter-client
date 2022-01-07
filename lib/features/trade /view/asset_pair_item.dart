import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';

class AssetPairItem extends StatelessWidget {
  AssetPairRecord _assetPairRecord;
  bool isSelected;

  AssetPairItem(this._assetPairRecord, this.isSelected);

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
          '${_assetPairRecord.base.code}/${_assetPairRecord.quote.code}',
          style: TextStyle(
              fontSize: 11.0,
              color:
                  isSelected ? colorScheme.secondaryText : colorScheme.accent),
        ),
      ),
    );
  }
}
