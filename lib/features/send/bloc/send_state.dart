import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';

class SendState extends Equatable {
  final Asset asset;
  final BalanceRecord? balanceRecord;
  final Decimal amount;
  final String recipient;
  final String notes;
  final bool isFormFilled;
  final bool isRequestReady;
  final bool isRequestConfirmed;
  final bool isRequestSubmitted;
  final Exception? error;

  SendState({
    required this.asset,
    this.balanceRecord,
    required this.amount,
    this.recipient = '',
    this.notes = '',
    this.isFormFilled = false,
    this.isRequestReady = false,
    this.isRequestConfirmed = false,
    this.isRequestSubmitted = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        asset,
        amount,
        balanceRecord,
        recipient,
        notes,
        isFormFilled,
        isRequestReady,
        isRequestConfirmed,
        isRequestSubmitted,
        error
      ];

  SendState copyWith({
    Decimal? amount,
    BalanceRecord? balanceRecord,
    Asset? asset,
    String? recipient,
    String? notes,
    bool? isFilled,
    bool? isRequestReady,
    bool? isRequestConfirmed,
    bool? isRequestSubmitted,
    Exception? error,
  }) {
    return SendState(
      asset: asset ?? this.asset,
      balanceRecord: balanceRecord ?? this.balanceRecord,
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      notes: notes ?? this.notes,
      isFormFilled: isFilled ?? this.isFormFilled,
      isRequestReady: isRequestReady ?? this.isRequestReady,
      isRequestConfirmed: isRequestConfirmed ?? this.isRequestConfirmed,
      isRequestSubmitted: isRequestSubmitted ?? this.isRequestSubmitted,
      error: error,
    );
  }
}

class SendInitial extends SendState {
  Asset asset;
  BalanceRecord balanceRecord;
  Decimal amount;
  String recipient;
  Exception? error;

  SendInitial(
      this.asset, this.balanceRecord, this.amount, this.recipient, this.error)
      : super(
            asset: asset,
            amount: amount,
            balanceRecord: balanceRecord,
            recipient: recipient,
            error: error);
}
