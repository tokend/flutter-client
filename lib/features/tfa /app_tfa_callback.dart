import 'dart:developer';

import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';

/// Application-wide TFA callback that allows screen-specific TFA handling.
class AppTfaCallback implements TfaCallback {
  var _handlers = List<TfaCallback>.of([]);

  /// Registers provided callback as a top priority TFA handler.
  registerHandler(TfaCallback tfaCallback) {
    _handlers.add(tfaCallback);
  }

  /// Unregisters provided callback which makes previous one a top priority TFA handler.
  unregisterHandler(TfaCallback tfaCallback) {
    _handlers.remove(tfaCallback);
  }

  @override
  Future<void> onTfaRequired(
      NeedTfaException exception, TfaVerifierInterface verifierInterface) {
    if (_handlers.isNotEmpty) {
      return _handlers.last.onTfaRequired(exception, verifierInterface);
    } else {
      log("No TFA handlers available, verification cancelled");
      verifierInterface.cancelVerification();
      return Future.value();
    }
  }
}
