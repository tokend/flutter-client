import 'package:dart_sdk/api/v3/params/order_book_params.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/trade%20/orderbook/model/order_book.dart';

class OrderBookRepository extends SingleItemRepository<OrderBook> {
  ApiProvider _apiProvider;
  String _baseAsset;
  String _quoteAsset;

  OrderBookRepository(this._apiProvider, this._baseAsset, this._quoteAsset);

  @override
  Future<OrderBook> getItem() {
    var api = _apiProvider.getApi();

    var builder = OrderBookParamsBuilder();
    builder.withMaxEntries(25);
    builder.withInclude([
      OrderBookParams.BUY_ENTRIES,
      OrderBookParams.SELL_ENTRIES,
      OrderBookParams.BASE_ASSET,
      OrderBookParams.QUOTE_ASSET,
    ]);

    String id =
        '$_baseAsset:$_quoteAsset:0'; //TODO check correctness of id setting
    return api.v3
        .getService()
        .get('v3/order_books/$id', query: builder.build().map())
        .then((response) => OrderBook.fromJson(response['data']));
  }
}
