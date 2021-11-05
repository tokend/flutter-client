import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/history/model/balance_change_action.dart';
import 'package:flutter_template/features/history/model/balance_change_cause.dart';

class BalanceChange {
  late String assetCode;
  late bool isReceived;
  late Decimal totalAmount;

  int id;
  BalanceChangeAction action;
  Decimal amount;
  Asset asset;
  String balanceId;
  SimpleFeeRecord fee;
  DateTime date;
  BalanceChangeCause cause;

  BalanceChange(this.id, this.action, this.amount, this.asset, this.balanceId,
      this.fee, this.date, this.cause) {
    assetCode = asset.code;
    isReceived = getIsReceivedState(action);

    ///Amount including fee
    if (isReceived && action != BalanceChangeAction.unlocked) {
      totalAmount = amount - fee.total;
    } else {
      totalAmount = amount + fee.total;
    }
  }

  bool getIsReceivedState(BalanceChangeAction action) {
    switch (action) {
      case BalanceChangeAction.locked:
        return false;
      case BalanceChangeAction.charged_from_locked:
        return false;
      case BalanceChangeAction.unlocked:
        return true;
      case BalanceChangeAction.charged:
        return false;
      case BalanceChangeAction.withdrawn:
        return false;
      case BalanceChangeAction.matched:
        return false;
      case BalanceChangeAction.issued:
        return true;
      case BalanceChangeAction.funded:
        return true;
    }
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is BalanceChange) && other.id == this.id;
  }
}
