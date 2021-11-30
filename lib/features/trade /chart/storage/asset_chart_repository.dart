import 'dart:convert';

import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/trade%20/chart/model/asset_chart_data.dart';

class AssetChartRepository extends SingleItemRepository<AssetChartData> {
  ApiProvider _apiProvider;
  late String _baseAssetCode;
  String? _quoteAssetCode;

  AssetChartRepository(
      this._apiProvider, this._baseAssetCode, this._quoteAssetCode)
      : super();

  /// Will return [AssetChartData] for given asset pair.
  @override
  Future<AssetChartData> getItem() async {
    var parameter = _baseAssetCode;
    if (_quoteAssetCode != null) {
      parameter = '$_baseAssetCode-$_quoteAssetCode';
    }
    var data = _apiProvider
        .getApi()
        .getService()
        .doGet('charts/$parameter', null, null)
        .then((response) {
      var data = json.decode(json.encode(response.data)) as Map<String, dynamic>;

      return AssetChartData.fromJson(data);
    });

    streamSubject.sink.add(await data);
    return data;
  }
}
