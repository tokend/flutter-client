

class AccountRole {
  static const UNKNOWN = '';
  static const UNVERIFIED = 'unverified';
  static const BLOCKED = 'blocked';
  static const GENERAL = 'general';
  static const CORPORATE = 'corporate';

  static const KEY_PREFIX = 'account_role';

  static List<String> roles = [
    UNVERIFIED,
    BLOCKED,
    GENERAL,
    CORPORATE,
  ];
  late String key;
  late bool isUnknown;

  AccountRole(String key, String isUnknown) {
    this.key = '$KEY_PREFIX:$key';
    this.isUnknown = key.isEmpty;
  }

  static String valueForKey(String key) {
    var value = UNKNOWN;
    roles.forEach((role) {
      if (key.contains(role)) {
        value = role;
      }
    });
    return value;
  }
}
