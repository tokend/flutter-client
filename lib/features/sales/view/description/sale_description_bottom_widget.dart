import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/dates.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/extensions/strings.dart';
import 'package:flutter_template/features/sales/model/sale_record.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DescriptionBottomWidget extends StatefulWidget {
  SaleRecord _saleRecord;

  DescriptionBottomWidget(this._saleRecord);

  @override
  State<DescriptionBottomWidget> createState() =>
      _DescriptionBottomWidgetState();
}

bool _expanded = false;

class _DescriptionBottomWidgetState extends State<DescriptionBottomWidget> {
  @override
  Widget build(BuildContext context) {
    var colorTheme = context.colorTheme;
    var currentCap = (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
        .currentCap
        .toInt();
    var softCap = (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
        .softCap
        .toInt();
    var hardCap = (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
        .hardCap
        .toInt();

    var fundedPercentage = (currentCap * 100 / softCap).round();
    var invested = currentCap;
    return SingleChildScrollView(
      child: Container(
        color: colorTheme.secondaryText,
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 26.0)),
            Row(
              children: [
                Icon(CustomIcons.calendar),
                Padding(padding: EdgeInsets.only(right: 8.0)),
                Flexible(
                  child: Text(
                    getStatusString(widget._saleRecord.saleState.name).format([
                      widget._saleRecord.endTime.format(FULL_DATE_AND_TIME)
                    ]),
                    maxLines: 2,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            Text(
              widget._saleRecord.name,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.0,
                  color: colorTheme.accent),
            ),
            Padding(padding: EdgeInsets.only(top: 12.0)),
            LinearProgressIndicator(
              value: fundedPercentage / 100,
              color: colorTheme.accent,
            ),
            Padding(padding: EdgeInsets.only(top: 14.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'funded_percentage'.tr.format(['$fundedPercentage%']),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: colorTheme.accent,
                  ),
                ),
                Text(
                  'invested_amount'.tr.format(
                      [invested, widget._saleRecord.defaultQuoteAsset.code]),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: colorTheme.accent,
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              'buy_for'.tr.format([
                softCap,
                widget._saleRecord.baseAsset.code,
                hardCap,
                widget._saleRecord.defaultQuoteAsset.code,
              ]),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 28.0, bottom: 24.0),
            ),
            Text(
              'descriptions'.tr,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            Text(
              widget._saleRecord.description,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: colorTheme.grayText,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 18.0)),
            Text(
              'sale_overview'.tr,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 14.0)),
            ExpansionTile(
              title: Text(
                'asset'.tr,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: colorTheme.primaryText),
              ),
              tilePadding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(title: Text('Not implemented yet')),
              ],
            ),
            ExpansionTile(
              title: Text(
                'details'.tr,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: colorTheme.primaryText),
              ),
              tilePadding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(title: Text('Not implemented yet')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getStatusString(String status) {
    switch (status) {
      case 'open':
        return 'is_opened_till'.tr;
      case 'closed':
        return 'is_closed_from'.tr;
      case 'canceled':
        return ''.tr;
    }
    return 'sale_closes_on'.tr;
  }
}
