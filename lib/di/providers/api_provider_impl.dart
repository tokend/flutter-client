import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/signing/account_request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/config/providers/url_config_provider.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tuple/tuple.dart';

class ApiProviderImpl implements ApiProvider {
  UrlConfigProvider _urlConfigProvider;
  AccountProvider _accountProvider;
  WalletInfoProvider _walletInfoProvider;
  TfaCallback? _tfaCallback;
  bool _withLogs = true;

  Lock lock = new Lock();

  ApiProviderImpl(this._urlConfigProvider, this._accountProvider,
      this._walletInfoProvider, this._tfaCallback, this._withLogs);

  String get _url => _urlConfigProvider.getConfig().api;

  Tuple2<int, TokenDApi>? apiByHash;
  Tuple2<int, TokenDApi>? signedApiByHash;

  @override
  TokenDApi getApi() {
    TokenDApi api;
    var hash = _url.hashCode;
    if (apiByHash != null && apiByHash!.item1 == hash) {
      api = apiByHash!.item2;
    } else {
      api = TokenDApi(_url,
          requestSigner: null, tfaCallback: _tfaCallback, withLogs: _withLogs);
    }
    apiByHash = Tuple2(hash, api);

    return api;
  }

  @override
  KeyServer getKeyServer() {
    return KeyServer(getApi().wallets);
  }

  @override
  TokenDApi? getSignedApi() {
    var account = _accountProvider.getAccount();
    if (account == null) return null;
    var originalAccountId = _walletInfoProvider
        .getWalletInfo()
        ?.accountId;
    if (originalAccountId == null) return null;
    var hash = hashValues(account.accountId, _url);

    var signedApi;
    if (signedApiByHash != null && signedApiByHash!.item1 == hash) {
      signedApi = signedApiByHash!.item2;
    } else {
      signedApi = TokenDApi(_url,
          requestSigner:
          AccountRequestSigner(account, accountId: originalAccountId),
          tfaCallback: _tfaCallback,
          withLogs: _withLogs);
    }
    signedApiByHash = Tuple2(hash, signedApi);
    return signedApi;
  }

  @override
  KeyServer? getSignedKeyServer() {
    var signedApi = getSignedApi();
    if (signedApi != null) {
      return KeyServer(signedApi.wallets);
    }
  }
}
