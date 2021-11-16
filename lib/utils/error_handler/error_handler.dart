abstract class ErrorHandler {
  bool handle(Exception error);

  String? getErrorMessage(Exception error);

  handleIfPossible(Exception error) {
    handle(error);
  }
}
