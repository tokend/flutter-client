import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';

abstract class SendEvent extends Equatable {
  const SendEvent();

  @override
  List<Object?> get props => [];
}

class BalanceChanged extends SendEvent {
  const BalanceChanged(this.balance);

  //final Asset? asset;
  final BalanceRecord? balance;

  @override
  List<Object?> get props => [balance];
}

class AmountChanged extends SendEvent {
  const AmountChanged(
    this.amount,
  );

  final Decimal? amount;

  @override
  List<Object?> get props => [amount];
}

class RecipientChanged extends SendEvent {
  const RecipientChanged(
    this.recipient,
  );

  final String? recipient;

  @override
  List<Object?> get props => [recipient];
}

class NoteChanged extends SendEvent {
  const NoteChanged(
    this.note,
  );

  final String? note;

  @override
  List<Object?> get props => [note];
}

class FormFilled extends SendEvent {
  const FormFilled(
    this.isFilled,
  );

  final bool? isFilled;

  @override
  List<Object?> get props => [isFilled];
}

class RequestConfirmed extends SendEvent {
  const RequestConfirmed(
    this.isRequestConfirmed,
  );

  final bool? isRequestConfirmed;

  @override
  List<Object?> get props => [isRequestConfirmed];
}

class RequestSubmitted extends SendEvent {
  const RequestSubmitted(
    this.isRequestSubmitted,
  );

  final bool? isRequestSubmitted;

  @override
  List<Object?> get props => [isRequestSubmitted];
}
