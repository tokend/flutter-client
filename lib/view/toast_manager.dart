import 'package:fluttertoast/fluttertoast.dart';

/// Simplifies interaction with [ToastManager]
class ToastManager {
  /// Shows a toast with [Toast.LENGTH_SHORT] length and given text
  void showLongToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  /// Shows a toast with [Toast.LENGTH_SHORT] length and given text
  void showShortToast(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
  }
}
