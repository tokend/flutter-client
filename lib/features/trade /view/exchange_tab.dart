import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart';
import 'package:flutter_template/features/trade%20/chart/model/chart_time_period.dart';
import 'package:flutter_template/features/trade%20/chart/storage/asset_chart_repository.dart';
import 'package:flutter_template/features/trade%20/chart/view%20/chart_view.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';
import 'package:flutter_template/features/trade%20/view/time_period_picker.dart';
import 'package:flutter_template/utils/formatters/string_formatter.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ExchangeTab extends BaseStatefulWidget {
  @override
  State<ExchangeTab> createState() => _ExchangeTabState();
}

int selectedAssetPairIndex = 0;
AssetPairRecord? selectedAssetPair;
ChartTimePeriod timePeriod = ChartTimePeriod.hour;
int selectedTimePeriod = 0;

var chartStreamController;
AssetChartRepository? chartRepository;
AssetPairsRepository? assetPairsRepository;

List<String> timePeriods = [
  describeEnum(ChartTimePeriod.hour).capitalize(),
  describeEnum(ChartTimePeriod.day).capitalize(),
  describeEnum(ChartTimePeriod.month).capitalize(),
  describeEnum(ChartTimePeriod.year).capitalize(),
];

class _ExchangeTabState extends State<ExchangeTab> {
  @override
  Widget build(BuildContext context) {
    assetPairsRepository = widget.repositoryProvider.assetPairsRepository;

    var assetPairsStreamController;

    void subscribeToChartsData() async {
      if (chartRepository?.isNeverUpdated == true) {
        await chartRepository?.getItem();
        chartRepository?.isNeverUpdated = false;
      }
    }

    void subscribeToAssetPairs() async {
      var items = await assetPairsRepository?.getItems();
      if (selectedAssetPair == null) selectedAssetPair = items!.first;

      if (this.mounted) {
        setState(() {
          chartRepository = widget.repositoryProvider.assetChartsRepository(
              selectedAssetPair!.base.code, selectedAssetPair!.quote.code);
          chartStreamController = chartRepository!.streamSubject;
        });
      }

      subscribeToChartsData();
    }

    if (assetPairsRepository?.isNeverUpdated == true) {
      subscribeToAssetPairs();
      assetPairsRepository?.isNeverUpdated = false;
    } else {
      if (chartRepository?.isFresh == false) {
        chartRepository = widget.repositoryProvider.assetChartsRepository(
            selectedAssetPair!.base.code, selectedAssetPair!.quote.code);
        chartStreamController = chartRepository!.streamSubject;
        subscribeToChartsData();
        chartRepository?.isFresh = true;
      }
    }

    assetPairsStreamController = assetPairsRepository?.streamSubject;
    var colorScheme = context.colorTheme;

    return Container(
      margin: EdgeInsets.only(left: 16.0, top: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<AssetPairRecord>>(
            initialData: [],
            stream: assetPairsStreamController?.stream,
            builder: (context, AsyncSnapshot<List<AssetPairRecord>> snapshot) {
              if (snapshot.data?.isEmpty == true &&
                  chartRepository?.isNeverUpdated == false &&
                  snapshot.connectionState != ConnectionState.waiting) {
                return Center(
                    child: Text(
                  'no_asset_pairs'.tr,
                  style: TextStyle(fontSize: 17.0),
                ));
              } else if (snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () {
                    return chartRepository!.update();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                          maxHeight: 95.0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: DropDownField<AssetPairRecord>(
                            onChanged: (newPair) {
                              setState(() {
                                selectedAssetPair = newPair;
                                chartRepository?.isFresh = false;
                              });
                            },
                            colorTheme: colorScheme,
                            currentValue:
                                selectedAssetPair ?? snapshot.data!.first,
                            list: snapshot.data!,
                            format: (AssetPairRecord item) {
                              return '${item.base.code}/${item.quote.code}';
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18.0, bottom: 16.0),
                        child: Text(
                          '${(selectedAssetPair ?? snapshot.data!.first).base.code}/${(selectedAssetPair ?? snapshot.data!.first).quote.code}',
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
              stream: chartStreamController?.stream,
              builder: (context, AsyncSnapshot<AssetChartData> snapshot) {
                if (snapshot.data == null &&
                    assetPairsRepository?.isNeverUpdated == false &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    'loading'.tr,
                    style: TextStyle(fontSize: 17.0),
                  ));
                } else if (snapshot.connectionState !=
                        ConnectionState.waiting &&
                    snapshot.hasData) {
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ChartView(snapshot.data!, timePeriod));
                } else if (snapshot.hasError) {
                  log(snapshot.stackTrace.toString());
                  return Text(snapshot.error
                      .toString()); // TODO display error correctly
                }
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()));
              }),
          Row(
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                  maxHeight: 45.0,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: timePeriods.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedTimePeriod != index) {
                          setState(() {
                            if (index == 0)
                              timePeriod = ChartTimePeriod.hour;
                            else if (index == 1)
                              timePeriod = ChartTimePeriod.day;
                            else if (index == 2)
                              timePeriod = ChartTimePeriod.month;
                            else if (index == 3)
                              timePeriod = ChartTimePeriod.year;
                            selectedTimePeriod = index;
                          });
                        }
                      },
                      child: Container(
                          child: TimePeriodPicker(
                              timePeriods[index], selectedTimePeriod == index)),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
