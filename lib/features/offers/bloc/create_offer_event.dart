import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';

abstract class CreateOfferEvent extends Equatable {
  const CreateOfferEvent();
}

class IsBuyChanged extends CreateOfferEvent {
  const IsBuyChanged(
    this.isBuy,
  );

  final bool? isBuy;

  @override
  List<Object?> get props => [isBuy];
}

class AmountChanged extends CreateOfferEvent {
  const AmountChanged(
    this.amount,
  );

  final Decimal? amount;

  @override
  List<Object?> get props => [amount];
}

class AssetPairChanged extends CreateOfferEvent {
  const AssetPairChanged(
    this.assetPair,
  );

  final AssetPairRecord? assetPair;

  @override
  List<Object?> get props => [assetPair];
}

class PriceChanged extends CreateOfferEvent {
  const PriceChanged(
    this.price,
  );

  final Decimal? price;

  @override
  List<Object?> get props => [price];
}

class FormFilled extends CreateOfferEvent {
  const FormFilled(
    this.isFilled,
  );

  final bool? isFilled;

  @override
  List<Object?> get props => [isFilled];
}

class RequestConfirmed extends CreateOfferEvent {
  const RequestConfirmed(
    this.isRequestConfirmed,
  );

  final bool? isRequestConfirmed;

  @override
  List<Object?> get props => [isRequestConfirmed];
}

class RequestSubmitted extends CreateOfferEvent {
  const RequestSubmitted(
    this.isRequestSubmitted,
  );

  final bool? isRequestSubmitted;

  @override
  List<Object?> get props => [isRequestSubmitted];
}
