abstract class Repository {
  bool isFresh = false;
  bool isLoading = false;
  bool isNeverUpdated = true;

  update();

  invalidate() {
    isFresh = false;
  }
}
