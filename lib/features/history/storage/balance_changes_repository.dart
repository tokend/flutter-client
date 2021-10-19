import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter_template/data/storage%20/model/paging_order.dart';
import 'package:flutter_template/data/storage%20/model/participant_effects_page_params.dart';
import 'package:flutter_template/data/storage%20/pagination/paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/paged_data_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/history/model/balance_change.dart';

abstract class BalanceChangesRepository
    extends PagedDataRepository<BalanceChange> {
  String? _balanceId;
  String? _accountId;
  ApiProvider _apiProvider;
  PagedDataCache<BalanceChange> dataCache;

  BalanceChangesRepository(
      this._balanceId, this._accountId, this._apiProvider, this.dataCache)
      : super(PagingOrder.desc, dataCache);

  @override
  Future<DataPage<BalanceChange>> getRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null) {
      return Future.error(StateError('No signed API instance found'));
    }

    var params = ParticipantEffectsPageParamsBuilder();
    params.withInclude(List.of([
      ParticipantEffectsParams.OPERATION,
      ParticipantEffectsParams.OPERATION_DETAILS,
      ParticipantEffectsParams.EFFECT,
    ]));

    if (_balanceId != null) {
      params.withBalance(_balanceId!);
    } else {
      params.withAccount(_accountId!);
    }

    return signedApi
        .getService()
        .get('v3/history', query: params.build().map())
        .then((response) => DataPage.fromPageDocument(response));
  }
}
