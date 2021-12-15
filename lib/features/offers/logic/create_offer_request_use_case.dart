import 'package:decimal/decimal.dart';
import 'package:flutter_template/base/model/simple_fee_record.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/fees/storage/fee_manager.dart';
import 'package:flutter_template/features/offers/model/offer_record.dart';
import 'package:flutter_template/features/offers/model/offer_request.dart';

/// Creates [OfferRequest]: loads fee for given amount
class CreateOfferRequestUseCase {
  Decimal _baseAmount;
  Decimal _price;
  Asset _baseAsset;
  Asset _quoteAsset;
  int _orderBookId;
  bool _isBuy;
  OfferRecord? _offerToCancel;
  WalletInfoProvider _walletInfoProvider;
  FeeManager _feeManager;

  late Decimal _quoteAmount = _baseAmount * _price;
  late String? _accountId;
  late SimpleFeeRecord _fee;

  CreateOfferRequestUseCase(
    this._baseAmount,
    this._price,
    this._baseAsset,
    this._quoteAsset,
    this._orderBookId,
    this._isBuy,
    this._offerToCancel,
    this._walletInfoProvider,
    this._feeManager,
  );

  Future<OfferRequest> perform() async {
    _accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (_accountId == null)
      return Future.error(StateError('Missing wallet info'));

    await setFee();
    return await getOfferRequest();
  }

  setFee() async {
    this._fee = await _feeManager.getFee(
      _orderBookId,
      _accountId!,
      _quoteAsset.code,
      _quoteAmount,
    );
  }

  Future<OfferRequest> getOfferRequest() {
    return Future.value(OfferRequest(_orderBookId, _price, _isBuy, _baseAsset,
        _quoteAsset, _baseAmount, _fee, _offerToCancel));
  }
}
