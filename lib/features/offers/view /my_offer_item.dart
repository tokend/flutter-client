import 'package:flutter/material.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class MyOfferItem extends StatelessWidget {
  OfferRecord offerRecord;

  MyOfferItem(this.offerRecord);

  @override
  Widget build(BuildContext context) {
    var colorTheme = context.colorTheme;
    var leftTextStyle = TextStyle(fontSize: 12.0, color: colorTheme.headerText);
    var rightTextStyle = TextStyle(
        fontSize: 13.0,
        color: colorTheme.headerText,
        fontWeight: FontWeight.w700);
    return Container(
      child: Card(
        color: colorTheme.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'order_id'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${offerRecord.id}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'date'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${offerRecord.date}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'order'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    'sc125zs64cz6', //TODO
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'base_asset_amount'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${offerRecord.baseAmount}',
                    style: rightTextStyle,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'price_in_quote_asset'.tr,
                    style: leftTextStyle,
                  ),
                  Text(
                    '${offerRecord.price} ${offerRecord.quoteAsset.code}',
                    style: rightTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
