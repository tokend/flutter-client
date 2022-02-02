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
  Future<OrderBook> getItem() async {
    var api = _apiProvider.getApi();

    var builder = OrderBookParamsBuilder();
    builder.withInclude([
      OrderBookParams.BUY_ENTRIES,
      OrderBookParams.SELL_ENTRIES,
      OrderBookParams.BASE_ASSET,
      OrderBookParams.QUOTE_ASSET,
    ]);

    String id =
        '$_baseAsset:$_quoteAsset:0'; //TODO check correctness of id setting
    var result = api.v3
        .getService()
        .get('v3/order_books/$id', query: builder.build().map())
        .then((response) {
      return OrderBook.fromJson(response['data'], response['included']);
    });

    streamSubject.add(await result);
    return result;
  }
}
