import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/dates.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/extensions/strings.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/assets/storage/assets_repository.dart';
import 'package:flutter_template/features/sales/model/sale_record.dart';
import 'package:flutter_template/features/sales/view/description/description_screen.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SaleListItem extends BaseStatefulWidget {
  SaleRecord _saleRecord;

  SaleListItem(this._saleRecord);

  @override
  State<SaleListItem> createState() => _SaleListItemState();
}

class _SaleListItemState extends State<SaleListItem> {
  @override
  Widget build(BuildContext context) {
    var streamController;
    AssetsRepository assetsRepository = widget.repositoryProvider.assets;

    void getAsset() async {
      await widget.repositoryProvider.activeKyc.getItem();
      widget.repositoryProvider.activeKyc.isNeverUpdated = false;
      await assetsRepository.getById(widget._saleRecord.baseAsset.code);
    }

    if (assetsRepository.isNeverUpdated == true) {
      getAsset();
    }

    streamController = assetsRepository.singleSubject;
    var colorTheme = context.colorTheme;
    return StreamBuilder<AssetRecord>(
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<AssetRecord> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            var currentCap =
                (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
                    .currentCap
                    .toInt();
            var softCap =
                (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
                    .softCap
                    .toInt();
            var hardCap =
                (widget._saleRecord.defaultQuoteAsset as SaleQuoteAsset)
                    .hardCap
                    .toInt();

            var fundedPercentage = (currentCap * 100 / softCap).round();
            var invested = currentCap;
            return Container(
              child: Card(
                color: colorTheme.secondaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                            width: 88.0,
                            height: 88.0,
                            child: snapshot.data!.logoUrl != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      height: 36.0,
                                      width: 36.0,
                                      child: Icon(CustomIcons.bitcoin__btc_),
                                    ),
                                    imageUrl: snapshot.data!.logoUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : CircularProfileAvatar(
                                    '',
                                    initialsText: Text(snapshot.data!.code
                                        .substring(0, 1)
                                        .capitalize()),
                                  ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget._saleRecord.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15.0),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6.0)),
                            Text(
                              widget._saleRecord.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15.0),
                            ),
                            Padding(padding: EdgeInsets.only(top: 14.0)),
                            Row(
                              children: [
                                Icon(CustomIcons.calendar),
                                Padding(padding: EdgeInsets.only(right: 8.0)),
                                Flexible(
                                  child: Text(
                                    getStatusString(
                                            widget._saleRecord.saleState.name)
                                        .format([
                                      widget._saleRecord.endTime
                                          .format(FULL_DATE_AND_TIME)
                                    ]),
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DescriptionScreen(
                                      widget._saleRecord, snapshot.data!)));
                        },
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
                            'funded_percentage'.tr.format([fundedPercentage]),
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: colorTheme.accent,
                            ),
                          ),
                          Text(
                            'invested_amount'.tr.format([
                              invested,
                              widget._saleRecord.defaultQuoteAsset.code
                            ]),
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
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
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
