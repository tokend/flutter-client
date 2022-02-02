import 'dart:developer';

import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/storage/account_identities_repository.dart';
import 'package:flutter_template/features/send/bloc/send_event.dart';
import 'package:flutter_template/features/send/bloc/send_state.dart';
import 'package:flutter_template/features/send/logic/confirm_payment_request_usecase.dart';
import 'package:flutter_template/features/send/logic/payment_request_usecase.dart';
import 'package:flutter_template/features/send/model/payment_fee.dart';
import 'package:flutter_template/features/send/model/payment_recipient.dart';
import 'package:flutter_template/features/send/model/payment_request.dart';
import 'package:get/get.dart';

class SendBloc extends BaseBloc<SendEvent, SendState> {
  SendBloc(SendState initialState) : super(initialState);
  late PaymentRequest? paymentRequest;

  @override
  Stream<SendState> mapEventToState(SendEvent event) async* {
    if (event is BalanceChanged) {
      yield state.copyWith(balanceRecord: event.balance);
    } else if (event is AmountChanged) {
      yield state.copyWith(amount: event.amount);
    } else if (event is RecipientChanged) {
      yield state.copyWith(recipient: event.recipient);
    } else if (event is NoteChanged) {
      yield state.copyWith(notes: event.note);
    } else if (event is FormFilled) {
      yield state.copyWith(isFilled: event.isFilled);

      WalletInfoProvider walletInfoProvider = session.walletInfoProvider;

      try {
        var recipient = await PaymentRecipientLoader(
                repositoryProvider.accountIdentitiesRepository)
            .load(state.recipient);
        log('got a recipient $recipient');
        this.paymentRequest = await CreatePaymentRequestUseCase(
                recipient,
                //TODO handle nickname setting
                state.amount,
                state.balanceRecord!,
                state.notes,
                PaymentFee(SimpleFeeRecord.zero, SimpleFeeRecord.zero, true),
                walletInfoProvider)
            .perform();
        yield state.copyWith(isRequestReady: true, error: null);
      } catch (e, stacktrace) {
        log(stacktrace.toString());
        if (e is NoIdentityAvailableException) {
          toastManager.showShortToast('error_invalid_recipient'.tr);
        } else if (e is Exception) {
          errorHandler.handle(e);
        }
        yield SendInitial(
          state.asset,
          state.balanceRecord!,
          state.amount,
          state.recipient,
          e as Exception,
        );
      }
    } else if (event is RequestConfirmed) {
      yield state.copyWith(isRequestConfirmed: event.isRequestConfirmed);
      AccountProvider accountProvider = session.accountProvider;

      if (this.paymentRequest != null) {
        try {
          await ConfirmPaymentRequestUseCase(this.paymentRequest!,
                  accountProvider, repositoryProvider, txManager)
              .perform();
          yield state.copyWith(isRequestSubmitted: true);
        } catch (e, stacktrace) {
          log(stacktrace.toString());
          if (e is InvalidRecipientException) {
            toastManager.showShortToast('error_invalid_recipient'.tr);
          } else if (e is Exception) {
            errorHandler.handle(e);
          }
          yield SendInitial(
            state.asset,
            state.balanceRecord!,
            state.amount,
            state.recipient,
            e as Exception,
          );
        }
      }
    }
  }
}
