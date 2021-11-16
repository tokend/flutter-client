import 'package:dart_sdk/api/v3/base/json_api_query_params.dart';

class AccountParams extends JsonApiQueryParams {
  static const FEES = 'fees';
  static const BALANCES = 'balances';
  static const BALANCES_ASSET = 'balances.asset';
  static const BALANCES_STATE = 'balances.state';
  static const REFERRER = 'referrer';
  static const LIMITS = 'limits';
  static const EXTERNAL_SYSTEM_IDS = 'fees';
  static const ROLE = 'role';
  static const ROLE_RULES = 'role.rules';
  static const KYC_DATA = 'kyc_data';

  AccountParams(List<String>? include) : super(include);
}
