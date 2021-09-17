class UrlConfig {
  String mApi;
  String mStorage;
  String mClient;
  bool withLogs;

  UrlConfig(this.mApi, this.mStorage, this.mClient, this.withLogs);

  String get api => mApi.addTrailSlashIfNeeded().addProtocolIfNeeded();

  String get storage => mStorage.addTrailSlashIfNeeded().addProtocolIfNeeded();

  String get client => mClient.addTrailSlashIfNeeded().addProtocolIfNeeded();
}

extension UrlConfigExt on String {
  String addTrailSlashIfNeeded() {
    var result = this;
    if (this[this.length - 1] != '/') {
      result = '$this/';
    }
    return result;
  }

  String addProtocolIfNeeded() {
    if (!contains(RegExp('^.+//'))) {
      return 'https://$this';
    } else if (startsWith('//')) {
      return 'https:$this';
    }
    return this;
  }
}
