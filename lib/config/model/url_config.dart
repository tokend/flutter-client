class UrlConfig {
  String mApi;
  String mStorage;
  String mClient;
  bool withLogs = true;

  UrlConfig(this.mApi, this.mStorage, this.mClient, this.withLogs);

  String get api => mApi.addTrailSlashIfNeeded().addProtocolIfNeeded();

  String get storage => mStorage.addTrailSlashIfNeeded().addProtocolIfNeeded();

  String get client => mClient.addTrailSlashIfNeeded().addProtocolIfNeeded();

  UrlConfig.fromJson(Map<String, dynamic> json)
      : mApi = json['api'],
        mStorage = json['storage'],
        mClient = json['client'];

  Map<String, dynamic> toJson() =>
      {'api': api, 'storage': storage, 'client': client};
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
