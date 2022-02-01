import 'dart:convert';
import 'dart:developer';

import 'package:dart_sdk/api/v3/params/identities_page_params.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/account/model/identity_resource_model.dart';
import 'package:flutter_template/features/send/model/payment_recipient.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AccountIdentitiesRepository {
  ApiProvider _apiProvider;

  AccountIdentitiesRepository(this._apiProvider);

  Set<AccountIdentityRecord> _identities = Set.identity();

  /// Loads account ID for given login.
  /// Result will be cached.
  ///
  /// [login] - email or phone number
  ///
  /// See [NoIdentityAvailableException]
  Future<String> getAccountIdByLogin(String login) async {
    var formattedLogin = login.toLowerCase();
    return (await getIdentity(IdentitiesPageParams(identifier: formattedLogin)))
        .accountId;
  }

  /// Loads login for given account ID.
  /// Result will be cached.
  ///
  /// See [NoIdentityAvailableException]
  Future<String> getLoginByAccountId(String accountId) async {
    var existing = _identities
        .toList()
        .firstWhereOrNull((identity) => identity.accountId == accountId)
        ?.login;

    if (existing != null) return Future.value(existing);
    return (await getIdentity(IdentitiesPageParams(address: accountId))).login;
  }

  Future<AccountIdentityRecord> getIdentity(
      IdentitiesPageParams identitiesPageParams) {
    return _apiProvider
        .getApi()
        .getService()
        .get('identities', query: identitiesPageParams.map())
        .then((response) {
      var data = json.decode(json.encode(response['data'])) as List<dynamic>;
      var identities =
          data.map((item) => IdentityResourceModel.fromJson(item)).toList();

      return AccountIdentityRecord.fromIdentityResource(identities.first);
    }).onError((error, stackTrace) {
      log('get identity error: $error $stackTrace');
      throw NoIdentityAvailableException();
    });
  }
}

class NoIdentityAvailableException implements Exception {}
