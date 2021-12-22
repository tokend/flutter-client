import 'dart:developer';

import 'package:dart_sdk/api/transactions/model/transaction_failed_exception.dart';
import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/extensions/strings.dart';
import 'package:flutter_template/features/fees/storage/fee_manager.dart';
import 'package:flutter_template/features/offers/logic/confirm_offer_request_use_case.dart';
import 'package:flutter_template/features/offers/logic/create_offer_request_use_case.dart';
import 'package:flutter_template/features/offers/model/offer_request.dart';

import 'create_offer_event.dart';
import 'create_offer_state.dart';

class CreateOfferBloc extends BaseBloc<CreateOfferEvent, CreateOfferState> {
  CreateOfferBloc(CreateOfferState initialState) : super(initialState);

  late OfferRequest _offerRequest;

  @override
  Stream<CreateOfferState> mapEventToState(CreateOfferEvent event) async* {
    if (event is AmountChanged) {
      yield state.copyWith(amount: event.amount);
    } else if (event is PriceChanged) {
      yield state.copyWith(price: event.price);
    } else if (event is AssetChanged) {
      yield state.copyWith(baseAsset: event.asset);
    } else if (event is IsBuyChanged) {
      yield state.copyWith(isBuy: event.isBuy);
    } else if (event is FormFilled) {
      yield state.copyWith(isFilled: event.isFilled);
      WalletInfoProvider walletInfoProvider = session.walletInfoProvider;

      var baseAsset =
          await repositoryProvider.orderBook('BTC', 'USD').getItem(); //TODO
      try {
        this._offerRequest = await CreateOfferRequestUseCase(
                state.amount,
                state.price,
                baseAsset.baseAsset,
                baseAsset.quoteAsset,
                0,
                true,
                null,
                walletInfoProvider,
                FeeManager(apiProvider))
            .perform();
        yield state.copyWith(isRequestReady: true, error: null);
      } catch (e, s) {
        log(e.toString());
        log(s.toString());
        yield state.copyWith(error: e as Exception);
      }
    } else if (event is RequestConfirmed) {
      yield state.copyWith(isRequestConfirmed: event.isRequestConfirmed);

      try {
        await ConfirmOfferRequestUseCase(_offerRequest, session.accountProvider,
                repositoryProvider, txManager)
            .perform();
        yield state.copyWith(isRequestSubmitted: true);
      } catch (e, s) {
        if (e is TransactionFailedException) {
          log('TransactionFailedException ${e.operationResultCodes.first}');
          e.transactionResultCode;
          e.submitTransactionResponse.resultMetaXdr?.printLongString();
        }
        log(e.toString());
        log(s.toString());
        yield state.copyWith(error: e as Exception);
      }
    }
  }
}
