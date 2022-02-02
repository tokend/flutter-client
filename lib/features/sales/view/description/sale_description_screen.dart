import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/sales/model/sale_record.dart';
import 'package:flutter_template/features/sales/view/description/sale_description_bottom_widget.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DescriptionScreen extends StatelessWidget {
  SaleRecord _saleRecord;
  AssetRecord _assetRecord;

  DescriptionScreen(this._saleRecord, this._assetRecord);

  @override
  Widget build(BuildContext context) {
    var colorTheme = context.colorTheme;
    return Scaffold(
      backgroundColor: colorTheme.secondaryText,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: colorTheme.background,
        leading: IconButton(
          icon: Icon(CustomIcons.add, color: Colors.black),
          //TODO change on custom icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'sale_details'.tr,
          style: TextStyle(color: colorTheme.headerText, fontSize: 17.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: Icon(CustomIcons.bitcoin__btc_),
                  ),
                  imageUrl: _assetRecord.logoUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            DescriptionBottomWidget(_saleRecord),
          ],
        ),
      ),
    );
  }
}
