import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';

class CreateOfferState extends Equatable {
  final Decimal amount;
  final bool isBuy;
  final Asset asset;
  final Decimal price;

  CreateOfferState({
    required this.amount,
    required this.isBuy,
    required this.asset,
    required this.price,
  });

  @override
  List<Object?> get props => [amount, isBuy, asset];

  CreateOfferState copyWith({
    Decimal? amount,
    Decimal? price,
    Asset? asset,
    bool? isBuy,
  }) {
    return CreateOfferState(
      asset: asset ?? this.asset,
      amount: amount ?? this.amount,
      isBuy: isBuy ?? this.isBuy,
      price: price ?? this.price,
    );
  }
}
