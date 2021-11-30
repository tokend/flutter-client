import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/chart/view%20/chart_view.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';
import 'package:flutter_template/features/trade%20/view/asset_pair_item.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ExchangeTab extends BaseStatefulWidget {
  @override
  State<ExchangeTab> createState() => _ExchangeTabState();
}

List<Widget> widgets = [
  TextButton(onPressed: () {}, child: Text('year')),
  TextButton(onPressed: () {}, child: Text('day')),
];
int selectedIndex = 0;
AssetPairRecord? selectedAssetPair;

class _ExchangeTabState extends State<ExchangeTab> {
  @override
  Widget build(BuildContext context) {
    AssetChartRepository chartRepository = widget.repositoryProvider
        .assetChartsRepository('BTC', 'USD'); // TODO remove hardcode
    AssetPairsRepository assetPairsRepository =
        widget.repositoryProvider.assetPairsRepository;

    var chartStreamController;
    var assetPairsStreamController;

    void subscribeToAssetPairs() async {
      var items = await assetPairsRepository.getItems();
      if (selectedAssetPair == null) selectedAssetPair = items.first;
    }

    void subscribeToChartsData() async {
      await chartRepository.getItem();
    }

    if (assetPairsRepository.isNeverUpdated == true) {
      subscribeToAssetPairs();
    }

    if (assetPairsRepository.isNeverUpdated == true) {
      subscribeToChartsData();
    }

    chartStreamController = chartRepository.streamSubject;
    assetPairsStreamController = assetPairsRepository.streamSubject;
    int selectedTimePeriod = 0;
    var colorScheme = context.colorTheme;

    return Container(
      margin: EdgeInsets.only(left: 16.0, top: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<AssetPairRecord>>(
            initialData: [],
            stream: assetPairsStreamController.stream,
            builder: (context, AsyncSnapshot<List<AssetPairRecord>> snapshot) {
              if (snapshot.data?.isEmpty == true &&
                  chartRepository.isNeverUpdated == false &&
                  snapshot.connectionState != ConnectionState.waiting) {
                return Center(
                    child: Text(
                  'empty_balances_list'.tr,
                  style: TextStyle(fontSize: 17.0),
                ));
              } else if (snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () {
                    return chartRepository.update();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                          maxHeight: 45.0,
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Builder(
                                builder: (BuildContext context) =>
                                    GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      selectedAssetPair = snapshot.data![index];
                                    });
                                  },
                                  child: Container(
                                    color: selectedIndex == index
                                        ? colorScheme.accent
                                        : colorScheme.background,
                                    child: AssetPairItem(snapshot.data![index],
                                        selectedIndex == index),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18.0, bottom: 16.0),
                        child: Text(
                          '${snapshot.data![selectedIndex].base.code}/${snapshot.data![selectedIndex].quote.code}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: colorScheme.accent,
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                log(snapshot.stackTrace.toString());
                return Text(
                    snapshot.error.toString()); // TODO display error correctly
              }
              return CircularProgressIndicator();
            },
          ),
          StreamBuilder<AssetChartData>(
              stream: chartStreamController.stream,
              builder: (context, AsyncSnapshot<AssetChartData> snapshot) {
                if (snapshot.data == null &&
                    assetPairsRepository.isNeverUpdated == false &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    'empty_balances_list'.tr,
                    style: TextStyle(fontSize: 17.0),
                  ));
                } else if (snapshot.connectionState !=
                        ConnectionState.waiting &&
                    snapshot.hasData) {
                  return ChartView(snapshot.data!);
                } else if (snapshot.hasError) {
                  log(snapshot.stackTrace.toString());
                  return Text(snapshot.error
                      .toString()); // TODO display error correctly
                }
                return Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }
}
