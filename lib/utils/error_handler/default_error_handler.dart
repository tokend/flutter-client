import 'package:dart_sdk/api/transactions/model/transaction_failed_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/utils/error_handler/error_handler.dart';
import 'package:flutter_template/view/toast_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DefaultErrorHandler implements ErrorHandler {
  ToastManager _toastManager;

  DefaultErrorHandler(this._toastManager);

  @override
  String? getErrorMessage(Exception error) {
    String message = 'error_try_again'.tr;
    if (error is TransactionFailedException) {
      message = getTransactionFailedMessage(error);
    } else if (error is DioError) {
      if (error.type == DioErrorType.connectTimeout) {
        message = 'error_connection_try_again'.tr;
      } else if (error.response?.statusCode == 401) {
        message = 'error_unauthorized'.tr;
      }
    }

    return message;
  }

  @override
  bool handle(Exception error) {
    String? message = getErrorMessage(error);
    if (message != null) {
      _toastManager.showShortToast(message);
      return true;
    }
    return false;
  }

  @override
  handleIfPossible(Exception error) {
    handle(error);
  }

  String getTransactionFailedMessage(TransactionFailedException exception) {
    String message = 'error_tx_general'.tr;
    switch (exception.transactionResultCode) {
      case TransactionFailedException.TX_FAILED:
        switch (exception.firstOperationResultCode) {
          case TransactionFailedException.OP_LIMITS_EXCEEDED:
            message = 'error_tx_limits'.tr;
            break;
          case TransactionFailedException.OP_INSUFFICIENT_BALANCE:
            message = 'error_tx_insufficient_balance'.tr;
            break;
          case TransactionFailedException.OP_INVALID_AMOUNT:
            message = 'error_tx_invalid_amount'.tr;
            break;
          case TransactionFailedException.OP_MALFORMED:
            message = 'error_tx_malformed'.tr;
            break;
          case TransactionFailedException.OP_ACCOUNT_BLOCKED:
            message = 'error_tx_account_blocked'.tr;
            break;
          case TransactionFailedException.OP_INVALID_FEE:
            message = 'error_tx_invalid_fee'.tr;
            break;
          case TransactionFailedException.OP_NO_ROLE_PERMISSION:
            message = 'error_tx_not_allowed'.tr;
            break;
          case TransactionFailedException.OP_OFFER_CROSS_SELF:
            message = 'error_tx_cross_self'.tr;
            break;
          case TransactionFailedException.OP_AMOUNT_LESS_THEN_DEST_FEE:
            message = 'error_payment_amount_less_than_fee'.tr;
            break;
          case TransactionFailedException.OP_REQUIRES_KYC:
            message = 'error_kyc_required_to_own_asset'.tr;
            break;
          case TransactionFailedException.OP_NOT_FOUND:
            message = 'error_tx_cross_self'.tr;
            break;
          case TransactionFailedException.OP_NO_ENTRY:
            message = 'error_tx_not_found'.tr;
            break;
        }
        break;
      case TransactionFailedException.TX_BAD_AUTH:
        message = 'error_tx_bad_auth'.tr;
        break;
      case TransactionFailedException.TX_NO_ROLE_PERMISSION:
        message = 'error_tx_not_allowed'.tr;
    }

    return message;
  }
}
