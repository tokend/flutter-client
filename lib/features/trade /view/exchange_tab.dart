import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pairs_repository.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExchangeTab extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetPairsRepository assetPairsRepository =
        repositoryProvider.assetPairsRepository;

    var streamController;

    void subscribeToAssetPairs() async {
      await assetPairsRepository.getItems();
    }

    if (assetPairsRepository.isNeverUpdated == true) {
      subscribeToAssetPairs();
    }

    streamController = assetPairsRepository.streamSubject;

    return StreamBuilder<List<AssetPairRecord>>(
        initialData: [],
        stream: streamController.stream,
        builder: (context, AsyncSnapshot<List<AssetPairRecord>> snapshot) {
          if (snapshot.data?.isEmpty == true &&
              assetPairsRepository.isNeverUpdated == false &&
              snapshot.connectionState != ConnectionState.waiting) {
            return Container(
              color: context.colorTheme.background,
              child: Center(
                  child: Text(
                'empty_balances_list'.tr,
                style: TextStyle(fontSize: 17.0),
              )),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            return Container(
              color: context.colorTheme.background,
              child: RefreshIndicator(
                  onRefresh: () {
                    return assetPairsRepository.update();
                  },
                  child: Column(children: [
                    //Initialize the chart widget
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: 'Half yearly sales analysis'),
                        // Enable legend
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<AssetPairRecord, String>>[
                          LineSeries<AssetPairRecord, String>(
                              dataSource: snapshot.data!,
                              xValueMapper: (AssetPairRecord sales, _) =>
                                  snapshot.data!.indexOf(sales).toString(),
                              yValueMapper: (AssetPairRecord sales, _) =>
                                  sales.price.toDouble(),
                              name: 'Sales',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true))
                        ])
                  ])),
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
