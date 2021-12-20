import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';
import 'package:dart_sdk/api/v3/params/offers_page_params_v3.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction.dart' as transaction;
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_template/data/storage%20/pagination/memory_only_paged_data_cache.dart';
import 'package:flutter_template/data/storage%20/repository/paged_data_repository.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';
import 'package:flutter_template/features/offers/model/offer_request.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';
import 'package:flutter_template/features/system_info/storage/system_info_repository.dart';
import 'package:flutter_template/logic/tx_manager.dart';

class OffersRepository extends PagedDataRepository<OfferRecord> {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;
  bool onlyPrimary; // != 0 for sales

  OffersRepository(
      this._apiProvider, this._walletInfoProvider, this.onlyPrimary)
      : super(PagingOrder.DESC, MemoryOnlyPagedDataCache<OfferRecord>());

  @override
  Future<DataPage<OfferRecord>> getRemotePage(
      int? nextCursor, PagingOrder requiredOrder) {
    var signedApi = _apiProvider.getSignedApi();
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      throw Future.error(StateError('No wallet info found'));

    var next = nextCursor ?? null;
    String? nextC;
    if (next != null) nextC = next.toString();
    var requestParams = OffersPageParamsV3(
        ownerAccount: accountId,
        isBuy: onlyPrimary == true ? onlyPrimary : null,
        pagingParamsV2: PagingParamsV2(nextC, pageLimit, requiredOrder),
        include: List.of([
          OffersParams.BASE_ASSET,
          OffersParams.QUOTE_ASSET,
        ]));

    return signedApi.v3
        .getService()
        .get('v3/offers', query: requestParams.map())
        .then((response) {
      var data = json.decode(json.encode(response['data'])) as List<dynamic>;
      var offers = data.map((item) => OfferRecord.fromJson(item)).toList();
      var nextLink = Uri.decodeFull(response['links']['next']);

      var limit = int.parse(
          DataPage.getNumberParamFromLink(nextLink, 'page\\[limit\\]') ?? "0");

      var isLast = response['links']['next'] == null || offers.length < limit;
      log('RESPONSE: $response');

      var nextCursor = DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']), 'page\\[cursor\\]') ??
          DataPage.getNumberParamFromLink(
              Uri.decodeFull(response['links']['next']),
              'page\\[number\\]'); //TODO rewrite with SDK static methods
      return DataPage((nextCursor), offers, isLast);
    });
  }

  Future<SubmitTransactionResponse?> create(
    AccountProvider accountProvider,
    SystemInfoRepository systemInfoRepository,
    TxManager txManager,
    String baseBalanceId,
    String quoteBalanceId,
    OfferRequest offerRequest, {
    OfferRecord? offerToCancel,
  }) {
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));
    var account = accountProvider.getAccount();
    if (account == null) return Future.error(StateError('No account found'));

    SystemInfoRecord systemInfoRecord =
        systemInfoRepository.streamSubject.value;
    NetworkParams networkParams = systemInfoRecord.toNetworkParams();
    return Future.value(null);
/*
    return createOfferCreationTransaction(networkParams, accountId, account,
            baseBalanceId, quoteBalanceId, offerRequest, offerToCancel)
        .then((transaction) => txManager.submit(transaction));*/
  }
/*
//TODO
  Future<transaction.Transaction> createOfferCreationTransaction(
    NetworkParams networkParams,
    String sourceAccountId,
    Account signer,
    String baseBalanceId,
    String quoteBalanceId,
    OfferRequest offerRequest,
    OfferRecord? offerToCancel,
  ) {
    return Future.value(offerToCancel)
        .then((offer) {
          var first = ManageOfferOp(
            PublicKeyFactory.fromBalanceId(offer.baseBalanceId),
            PublicKeyFactory.fromBalanceId(offer.quoteBalanceId),
            offer.isBuy,
            Int64.ZERO,
            Int64(networkParams.amountToPrecised(offer.price.toDouble())),
            Int64(networkParams.amountToPrecised(offer.fee.total.toDouble())),
            Int64(offer.id),
            Int64(offer.orderBookId),
            ManageOfferOpExtEmptyVersion(),
          );
          var second = ManageOfferOp(
            PublicKeyFactory.fromBalanceId(baseBalanceId),
            PublicKeyFactory.fromBalanceId(quoteBalanceId),
            offerRequest.isBuy,
            Int64(networkParams
                .amountToPrecised(offerRequest.baseAmount.toDouble())),
            Int64(
                networkParams.amountToPrecised(offerRequest.price.toDouble())),
            Int64(networkParams
                .amountToPrecised(offerRequest.fee.total.toDouble())),
            Int64.ZERO,
            Int64(offerRequest.orderBookId),
            ManageOfferOpExtEmptyVersion(),
          );

          return List.of([first, second]);
        })
        .then((operations) =>
            operations.map((op) => OperationBodyManageOffer(op)).toList())
        .then((operations) => TxManager.createSignedTransaction(
            networkParams, sourceAccountId, signer, operations));
  }*/
}
