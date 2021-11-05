abstract class BalanceChangeCause {}

class Offer extends BalanceChangeCause {}

class MatchedOffer extends BalanceChangeCause {}

class Investment extends BalanceChangeCause {}

class SaleCancellation extends BalanceChangeCause {}

class OfferCancellation extends BalanceChangeCause {}

class Issuance extends BalanceChangeCause {}

class Payment extends BalanceChangeCause {}

class WithdrawalRequest extends BalanceChangeCause {}

class AssetPairUpdate extends BalanceChangeCause {}

class AtomicSwapAskCreation extends BalanceChangeCause {}

class AtomicSwapBidCreation extends BalanceChangeCause {}

class Unknown extends BalanceChangeCause {}

class AmlAlert extends BalanceChangeCause {}
