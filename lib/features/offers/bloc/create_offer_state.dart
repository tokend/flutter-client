import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';

class CreateOfferState extends Equatable {
  final Decimal amount;
  final bool isBuy;
  final Asset baseAsset;
  final Asset quoteAsset;
  final Decimal price;
  final bool isFormFilled;
  final bool isRequestReady;
  final bool isRequestConfirmed;
  final bool isRequestSubmitted;
  final Exception? error;

  CreateOfferState({
    required this.amount,
    required this.isBuy,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    this.isFormFilled = false,
    this.isRequestReady = false,
    this.isRequestConfirmed = false,
    this.isRequestSubmitted = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        amount,
        isBuy,
        baseAsset,
        isFormFilled,
        isRequestReady,
        isRequestConfirmed,
        isRequestSubmitted,
        error,
      ];

  CreateOfferState copyWith({
    Decimal? amount,
    Decimal? price,
    Asset? baseAsset,
    Asset? quoteAsset,
    bool? isBuy,
    bool? isFilled,
    bool? isRequestReady,
    bool? isRequestConfirmed,
    bool? isRequestSubmitted,
    Exception? error,
  }) {
    return CreateOfferState(
      baseAsset: baseAsset ?? this.baseAsset,
      quoteAsset: quoteAsset ?? this.quoteAsset,
      amount: amount ?? this.amount,
      isBuy: isBuy ?? this.isBuy,
      price: price ?? this.price,
      isFormFilled: isFilled ?? this.isFormFilled,
      isRequestReady: isRequestReady ?? this.isRequestReady,
      isRequestConfirmed: isRequestConfirmed ?? this.isRequestConfirmed,
      isRequestSubmitted: isRequestSubmitted ?? this.isRequestSubmitted,
      error: error,
    );
  }
}
