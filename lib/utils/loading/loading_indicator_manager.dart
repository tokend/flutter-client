/// Manages loading indicator visibility when there are few parallel tasks which requires it.
/// I.e. task A and task B running simultaneously can use can use this manager to display
/// loading state with different tags.
/// Loading indicator will be shown if at least one loading request is present
/// and will be hidden if all loading requests has been cancelled.
class LoadingIndicatorManager {
  List<String> loadingRequests = [];
  bool isLoading = false;

  Function startLoading;
  Function stopLoading;

  LoadingIndicatorManager(this.startLoading, this.stopLoading);

  /// Sets loading state with given tag
  setLoading(bool isLoading, {tag = 'main'}) {
    if (isLoading) {
      show(tag: tag);
    } else {
      hide(tag: tag);
    }
  }

  /// Shows loading with given tag
  show({tag = ''}) {
    loadingRequests.add(tag);
    updateVisibility();
  }

  /// Hides loading with given tag
  hide({tag = ''}) {
    loadingRequests.remove(tag);
    updateVisibility();
  }

  updateVisibility() {
    if (loadingRequests.length > 0) {
      if (!isLoading) startLoading.call();
      isLoading = true;
    } else {
      var wasLoading = isLoading;
      isLoading = false;
      if (wasLoading) stopLoading.call();
    }
  }
}
