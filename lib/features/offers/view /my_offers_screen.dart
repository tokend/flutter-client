import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/extensions/strings.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';
import 'package:flutter_template/features/offers/storage/offers_repository.dart';
import 'package:flutter_template/features/offers/view%20/my_offer_item.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class MyOffersScreen extends BaseStatefulWidget {
  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

AssetPairRecord? currentAssetPair;

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  Widget build(BuildContext context) {
    OffersRepository offersRepository =
        widget.repositoryProvider.offersRepository;
    var streamController;

    void subscribeToOffers() async {
      await offersRepository.update();
      offersRepository.isNeverUpdated = false;
    }

    if (currentAssetPair == null) {
      currentAssetPair = widget
          .repositoryProvider.assetPairsRepository.streamSubject.value.first;
    }
    if (offersRepository.isNeverUpdated) {
      subscribeToOffers();
    }

    streamController = offersRepository.streamController;
    return StreamBuilder<List<OfferRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<OfferRecord>> snapshot) {
          var filteredByAssetPair = snapshot.data!
              .where((offerRecord) =>
                  offerRecord.baseAsset.code == currentAssetPair?.base.code &&
                  offerRecord.quoteAsset.code == currentAssetPair?.quote.code)
              .toList();
          if (snapshot.data?.isEmpty ==
                      true && //TODO add 'empty list' message for empty filtered list
                  offersRepository.isNeverUpdated == false &&
                  snapshot.connectionState !=
                      ConnectionState
                          .waiting /*||
              offersRepository.isNeverUpdated == false &&
                  snapshot.connectionState != ConnectionState.waiting &&
                  filteredByAssetPair.isEmpty*/
              ) {
            return Container(
              color: context.colorTheme.background,
              child: Center(
                  child: Text(
                'empty_offers_list'.tr,
                style: TextStyle(fontSize: 17.0),
              )),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            offersRepository.isNeverUpdated = false;

            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                onRefresh: () {
                  return offersRepository.update();
                },
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 24.0, right: 24.0, bottom: 24.0),
                        child: DropDownField<AssetPairRecord>(
                          onChanged: (newPair) {
                            setState(() {
                              currentAssetPair = newPair;
                            });
                          },
                          colorTheme: context.colorTheme,
                          currentValue: currentAssetPair,
                          list: widget.repositoryProvider.assetPairsRepository
                              .streamSubject.value,
                          format: (AssetPairRecord item) {
                            return '${item.base.code}/${item.quote.code}';
                          },
                        )),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      'open_orders'.tr.format([
                        '${currentAssetPair?.base.code}/${currentAssetPair?.quote.code}'
                      ]),
                      style: TextStyle(
                          color: context.colorTheme.drawerBackground,
                          fontSize: 22.0),
                    ),
                    Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          separatorBuilder:
                              (BuildContext context, int index) =>
                              Divider(height: 2),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: filteredByAssetPair.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Builder(
                                builder: (BuildContext context) =>
                                    MyOfferItem(filteredByAssetPair[index]));
                          }),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.stackTrace.toString());
            return Text(
                snapshot.error.toString()); // TODO display error correctly
          }
          return Container(
              color: context.colorTheme.background,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}
