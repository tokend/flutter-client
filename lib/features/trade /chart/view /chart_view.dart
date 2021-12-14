import 'package:flutter/cupertino.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart'
    as charts;
import 'package:flutter_template/features/trade%20/chart/model/chart_time_period.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  charts.AssetChartData assetPairs;
  ChartTimePeriod timePeriod;

  ChartView(this.assetPairs, this.timePeriod);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<charts.ChartPoint, String>>[
          LineSeries<charts.ChartPoint, String>(
            dataSource: getDataSourceByTimePeriod(assetPairs)!,
            xValueMapper: (charts.ChartPoint point, _) =>
                getDataSourceByTimePeriod(assetPairs)!
                    .indexOf(point)
                    .toString(),
            yValueMapper: (charts.ChartPoint point, _) =>
                point.value.toDouble(),
          )
        ]);
  }

  List<charts.ChartPoint>? getDataSourceByTimePeriod(
      charts.AssetChartData assetPairs) {
    switch (timePeriod) {
      case ChartTimePeriod.day:
        return assetPairs.day?.toList();
      case ChartTimePeriod.hour:
        return assetPairs.hour?.toList();
      case ChartTimePeriod.month:
        return assetPairs.month?.toList();
      case ChartTimePeriod.year:
        return assetPairs.year?.toList();
    }
  }
}
