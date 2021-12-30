import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:flutter_template/features/tfa%20/storage/tfa_factors_repository.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// Disables current active 2FA factor of given type
class DisableTfaUseCase {
  TfaFactorType _factorType;
  TfaFactorsRepository _factorsRepository;

  DisableTfaUseCase(this._factorType, this._factorsRepository);

  perform() {
    _factorsRepository.update().then((_) => _deleteFactorIfActive());
  }

  Future<bool> _deleteFactorIfActive() {
    var currentFactor = _factorsRepository.streamSubject.value
        .firstWhereOrNull((item) => item.type == _factorType);

    if (currentFactor != null && currentFactor.priority > 0) {
      _factorsRepository.deleteFactor(currentFactor.id);
      return Future.value(true);
    }

    return Future.value(false);
  }
}
