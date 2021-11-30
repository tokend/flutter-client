import 'package:flutter/cupertino.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart'
    as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  charts.AssetChartData assetPairs;

  ChartView(this.assetPairs);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<charts.ChartPoint, String>>[
          LineSeries<charts.ChartPoint, String>(
            dataSource: assetPairs.day!.toList(),
            xValueMapper: (charts.ChartPoint point, _) =>
                assetPairs.day!.indexOf(point).toString(),
            yValueMapper: (charts.ChartPoint point, _) =>
                point.value.toDouble(),
          )
        ]);
  }
}
