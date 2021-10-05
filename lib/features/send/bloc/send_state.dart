import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/assets/model/asset_record.dart';
import 'package:flutter_template/features/assets/model/simple_asset.dart';
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
        isRequestConfirmed
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
      error: error ?? this.error,
    );
  }
}

class SendInitial extends SendState {
  SendInitial()
      : super(
            asset: SimpleAsset('BTC', 'Bitcoin', 6),
            amount: Decimal.fromInt(0),
            balanceRecord: BalanceRecord(
                'BAWKBCNP7XTLGO5YXTRMC6M2AIYQP6LDHKYHASDLAOGRXRLA7I74HWHZ',
                AssetRecord('BTC', 'Bitcoin', 6, null,
                    'GBA4EX43M25UPV4WIE6RRMQOFTWXZZRIPFAI5VPY6Z2ZVVXVWZ6NEOOB'),
                100));//TODO
}
