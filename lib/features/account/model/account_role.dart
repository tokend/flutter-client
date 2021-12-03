class AccountRole {
  static const UNKNOWN = '';
  static const BLOCKED = 'blocked';
  static const GENERAL = 'general';
  static const CORPORATE = 'corporate';
  static const KEY_PREFIX = 'account_role';

  late String key;
  late bool isUnknown;

  AccountRole(String key, String isUnknown) {
    this.key = '$KEY_PREFIX:$key';
    this.isUnknown = key.isEmpty;
  }
}
