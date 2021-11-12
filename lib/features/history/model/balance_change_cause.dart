/// Financial action resulted in the balance change
abstract class BalanceChangeCause {}

class Offer extends BalanceChangeCause {}

class MatchedOffer extends BalanceChangeCause {}

class Investment extends BalanceChangeCause {}

class SaleCancellation extends BalanceChangeCause {}

class OfferCancellation extends BalanceChangeCause {}

class Issuance extends BalanceChangeCause {}

class Payment extends BalanceChangeCause {
  String sourceAccountId;
  String destAccountId;
  String? sourceName;
  String? destName;

  Payment(this.sourceAccountId, this.destAccountId,
      {this.sourceName, this.destName});

  bool isReceived(String accountId) {
    return destAccountId == accountId;
  }

  String getCounterPartyAccountId(String yourAccountId) {
    if (isReceived(yourAccountId)) {
      return sourceAccountId;
    }

    return destAccountId;
  }
}

class WithdrawalRequest extends BalanceChangeCause {}

class AssetPairUpdate extends BalanceChangeCause {}

class AtomicSwapAskCreation extends BalanceChangeCause {}

class AtomicSwapBidCreation extends BalanceChangeCause {}

class Unknown extends BalanceChangeCause {}

class AmlAlert extends BalanceChangeCause {}
