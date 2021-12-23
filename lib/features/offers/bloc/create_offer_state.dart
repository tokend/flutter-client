import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';

class CreateOfferState extends Equatable {
  final Decimal amount;
  final bool isBuy;
  final AssetPairRecord assetPairRecord;
  final Decimal price;
  final bool isFormFilled;
  final bool isRequestReady;
  final bool isRequestConfirmed;
  final bool isRequestSubmitted;
  final Exception? error;

  CreateOfferState({
    required this.amount,
    required this.isBuy,
    required this.assetPairRecord,
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
        price,
        isBuy,
        isFormFilled,
        isRequestReady,
        isRequestConfirmed,
        isRequestSubmitted,
        error,
        assetPairRecord,
      ];

  CreateOfferState copyWith({
    Decimal? amount,
    Decimal? price,
    Asset? baseAsset,
    Asset? quoteAsset,
    AssetPairRecord? assetPairRecord,
    bool? isBuy,
    bool? isFilled,
    bool? isRequestReady,
    bool? isRequestConfirmed,
    bool? isRequestSubmitted,
    Exception? error,
  }) {
    return CreateOfferState(
      assetPairRecord: assetPairRecord ?? this.assetPairRecord,
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
