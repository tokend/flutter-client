import 'package:decimal/decimal.dart';

class AssetChartData {
  List<ChartPoint>? hour;
  List<ChartPoint>? day;
  List<ChartPoint>? week;
  List<ChartPoint>? month;
  List<ChartPoint>? year;

  AssetChartData.fromJson(Map<dynamic, dynamic> json)
      : hour = (json['hour'] as List<dynamic>)
            .map((point) => ChartPoint.fromJson(point))
            .toList(),
        day = (json['day'] as List<dynamic>)
            .map((point) => ChartPoint.fromJson(point))
            .toList(),
        week = (json['week'] as List<dynamic>)
            .map((point) => ChartPoint.fromJson(point))
            .toList(),
        month = (json['month'] as List<dynamic>)
            .map((point) => ChartPoint.fromJson(point))
            .toList(),
        year = (json['year'] as List<dynamic>)
            .map((point) => ChartPoint.fromJson(point))
            .toList();
}

class ChartPoint {
  Decimal value;
  String timestamp;

  ChartPoint(this.value, this.timestamp);

  DateTime? parsedDate;

  ChartPoint.fromJson(Map<String, dynamic> json)
      : value = Decimal.parse(json['value']),
        timestamp = json['timestamp'];
}
