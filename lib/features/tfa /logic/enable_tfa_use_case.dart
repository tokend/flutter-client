import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:flutter_template/features/tfa%20/storage/tfa_factors_repository.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// Adds and enables 2FA factor of given type.
/// In order to enable 2FA factor user will be asked for OTP from it
///
/// [newFactorConfirmation] will be called when the new factor is added but not yet enabled
class EnableTfaUseCase {
  TfaFactorType _factorType;
  TfaFactorsRepository _factorsRepository;

  EnableTfaUseCase(this._factorType, this._factorsRepository);

  late Map<String, dynamic> creationResult;

  perform() {
    _factorsRepository
        .update()
        .then((_) => _deleteOldFactorIfNeeded())
        .then((_) => _addNewFactor())
        .then((creationResult) => this.creationResult = creationResult)
        .then((value) => _enableNewFactor());
  }

  Future<Map<String, dynamic>>? _deleteOldFactorIfNeeded() {
    var oldFactor = _factorsRepository.streamSubject.value
        .firstWhereOrNull((element) => element.type == _factorType);
    if (oldFactor != null) {
      return _factorsRepository.deleteFactor(oldFactor.id);
    }
  }

  Future<Map<String, dynamic>> _addNewFactor() {
    return _factorsRepository.addFactor(_factorType);
  }

  Future<Map<String, dynamic>> _enableNewFactor() {
    return _factorsRepository
        .setFactorAsMain(creationResult['new_factor']['id']);
  }
}
