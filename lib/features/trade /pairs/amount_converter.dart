import 'package:decimal/decimal.dart';

abstract class AmountConverter {
  /// return multiplier for conversion from source asset to dest one.
  /// If there is no such pair [null] will be returned.
  Decimal? getRate(String sourceAsset, String destAsset);

  /// return multiplier for conversion from source asset to dest one.
  /// If there is no such pair "1" will be returned.
  Decimal getRateOrOne(String sourceAsset, String destAsset) {
    return getRate(sourceAsset, destAsset) ?? Decimal.one;
  }

  /// return amount converted from source asset to dest one using found rate
  /// or [null] if no rate found.
  Decimal? convert(Decimal amount, String sourceAsset, String destAsset);

  /// return amount converted from source asset to dest one using found rate
  /// or same one if no rate found.
  Decimal convertOrSame(Decimal amount, String sourceAsset, String destAsset) {
    return convert(amount, sourceAsset, destAsset) ?? amount;
  }
}
