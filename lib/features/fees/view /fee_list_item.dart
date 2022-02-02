import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/fees/model/fee_record.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';

class FeeListItem extends StatefulWidget {
  FeeRecord _feeRecord;

  FeeListItem(this._feeRecord);

  @override
  State<FeeListItem> createState() => _FeeListItemState();
}

class _FeeListItemState extends State<FeeListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorTheme.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (BuildContext context) => GestureDetector(
          onTap: () {
            /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssetDetailsScreen(assetRecord)));*/
          },
          child: ListTile(
            minLeadingWidth: 12,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                width: 36.0,
                height: 36.0,
                child: CircularProfileAvatar(
                  '',
                  initialsText: Text(widget._feeRecord.asset.code
                      .substring(0, 1)
                      .capitalize()),
                ),
              ),
            ),
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${widget._feeRecord.asset.name} (${widget._feeRecord.asset.code})',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                ),
                Row(
                  children: [
                    Text(
                        '${widget._feeRecord.asset.code} ${widget._feeRecord.asset.code}'),
                  ],
                )
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right), //TODO add custom icon
          ),
        ),
      ),
    );
  }
}
