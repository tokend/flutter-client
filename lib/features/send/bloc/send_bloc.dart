import 'dart:developer';

import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/send/bloc/send_event.dart';
import 'package:flutter_template/features/send/bloc/send_state.dart';
import 'package:flutter_template/features/send/logic/confirm_payment_request_usecase.dart';
import 'package:flutter_template/features/send/logic/payment_request_usecase.dart';
import 'package:flutter_template/features/send/model/payment_fee.dart';
import 'package:flutter_template/features/send/model/payment_recipient.dart';
import 'package:flutter_template/features/send/model/payment_request.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:get/get.dart';

class SendBloc extends BaseBloc<SendEvent, SendState> {
  SendBloc(SendState initialState) : super(initialState);
  late PaymentRequest? paymentRequest;

  @override
  Stream<SendState> mapEventToState(SendEvent event) async* {
    if (event is AssetChanged) {
      yield state.copyWith(asset: event.asset, balanceRecord: event.balance);
    } else if (event is AmountChanged) {
      yield state.copyWith(amount: event.amount);
    } else if (event is RecipientChanged) {
      yield state.copyWith(recipient: event.recipient);
    } else if (event is NoteChanged) {
      yield state.copyWith(notes: event.note);
    } else if (event is FormFilled) {
      yield state.copyWith(isFilled: event.isFilled);

      WalletInfoProvider walletInfoProvider = Get.find();

      try {
        this.paymentRequest = await CreatePaymentRequestUseCase(
                PaymentRecipient(
                    state.recipient, 'nickname is not set for now'),
                state.amount,
                state.balanceRecord!,
                state.notes,
                PaymentFee(SimpleFeeRecord.zero, SimpleFeeRecord.zero, true),
                walletInfoProvider)
            .perform();
        yield state.copyWith(isRequestReady: true);
      } catch (e, stacktrace) {
        log(stacktrace.toString());
        yield state.copyWith(error: e as Exception);
      }
    } else if (event is RequestCreated) {
      AccountProvider accountProvider = Get.find();
      TxManager txManager = Get.find();
      RepositoryProvider repositoryProvider = Get.find();

      if (this.paymentRequest != null) {
        try {
          await ConfirmPaymentRequestUseCase(this.paymentRequest!,
                  accountProvider, repositoryProvider, txManager)
              .perform();
          yield state.copyWith(isFilled: event.isRequestCreated);
        } catch (e, stacktrace) {
          log(stacktrace.toString());
          yield state.copyWith(error: e as Exception);
        }
      }
    }
  }
}
