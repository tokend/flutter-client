import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/balances/storage/balances_repository.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';
import 'package:flutter_template/features/offers/model/offer_request.dart';
import 'package:flutter_template/features/offers/storage/offers_repository.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:tuple/tuple.dart';

class ConfirmOfferRequestUseCase {
  OfferRequest _request;
  AccountProvider _accountProvider;
  RepositoryProvider _repositoryProvider;
  TxManager _txManager;

  late OfferRecord _offerToCancel;
  late var _cancellationOnly;
  late var _isPrimaryMarket;

  late NetworkParams networkParams;
  late String baseBalanceId;
  late String quoteBalanceId;
  late String resultMeta;

  OffersRepository get _offersRepository =>
      _repositoryProvider.offersRepository;

  SystemInfoRepository get _systemInfo => _repositoryProvider.systemInfo;

  BalancesRepository get _balancesRepository => _repositoryProvider.balances;

  ConfirmOfferRequestUseCase(this._request, this._accountProvider,
      this._repositoryProvider, this._txManager) {
    _offerToCancel = _request.offerToCancel;
  }

  perform() {
    _updateBalances().then((balances) => null);
  }

  /*Future<List<BalanceRecord>>*/ _updateBalances() async {
    var balances = await _balancesRepository.getItems();
    getBalances(balances)
        .then((baseQuoteTuple) {
          this.baseBalanceId = baseQuoteTuple.item1;
          this.quoteBalanceId = baseQuoteTuple.item2;

          _offerToCancel.baseBalanceId = baseQuoteTuple.item1;
          _offerToCancel.quoteBalanceId = baseQuoteTuple.item2;
        })
        .then((_) => getNetworkParams())
        .then((networkParams) => this.networkParams = networkParams)
        .then((_) => _submitOfferActions())
        .then((response) => this.resultMeta = response.resultMetaXdr!);
    //TODO update repos
  }

  Future<Tuple2<String, String>> getBalances(List<BalanceRecord> balances) {
    var baseAsset = _request.baseAsset;
    var quoteAsset = _request.quoteAsset;

    var existingBase = balances
        .firstWhereOrNull((balance) => balance.asset.code == baseAsset.code);
    var existingQuote = balances
        .firstWhereOrNull((balance) => balance.asset.code == quoteAsset.code);

    var toCreate = [];
    if (existingBase == null) {
      toCreate.add(baseAsset.code);
    }
    if (existingQuote == null) {
      toCreate.add(quoteAsset.code);
    }

    var base = _balancesRepository.streamSubject.value
        .firstWhere((balance) => balance.asset.code == baseAsset.code)
        .id;
    var quote = _balancesRepository.streamSubject.value
        .firstWhere((balance) => balance.asset.code == quoteAsset.code)
        .id;

    return Future.value(Tuple2(base, quote));
  }

  Future<NetworkParams> getNetworkParams() {
    return _repositoryProvider.systemInfo
        .getItem()
        .then((systemInfoRecord) => systemInfoRecord.toNetworkParams());
  }

  Future<SubmitTransactionResponse> _submitOfferActions() {
    var result;
    if (!_cancellationOnly) {
      result = _offersRepository.create(_accountProvider, _systemInfo,
          _txManager, baseBalanceId, quoteBalanceId, _offerToCancel);
    } //TODO

    return result;
  }
}

/*
*
*  private val offerToCancel = request.offerToCancel

    private val cancellationOnly = request.baseAmount.signum() == 0 && offerToCancel != null

    private val isPrimaryMarket = request.orderBookId != 0L

    private val offersRepository: OffersRepository
        get() = repositoryProvider.offers(isPrimaryMarket)

    private val systemInfoRepository: SystemInfoRepository
        get() = repositoryProvider.systemInfo

    private val balancesRepository: BalancesRepository
        get() = repositoryProvider.balances
*/
