import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dcache/dcache.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';

class BlobsRepository {
  ApiProvider _apiProvider;
  WalletInfoProvider _walletInfoProvider;

  BlobsRepository(this._apiProvider, this._walletInfoProvider);

  LruCache _cache = LruCache<String, Blob>(
      storage: InMemoryStorage<String, Blob>(CACHE_SIZE));

  Future<Blob> getById(String blobId, {bool isPrivate = false}) {
    TokenDApi? api;
    if (isPrivate) {
      api = _apiProvider.getSignedApi();
      if (api == null)
        return Future.error(
            StateError('Cannot get signed API to load private blob'));
    } else {
      api = _apiProvider.getApi();
    }

    var cachedBlob = _cache[blobId];
    if (cachedBlob == null) {
      cachedBlob =
          api.blobs.getBlob(blobId).then((blob) => _cache[blobId] = blob);
    } else {
      cachedBlob = Future.value(cachedBlob);
    }
    return cachedBlob;
  }

  Future<Blob> create(Blob blob) {
    var signedApi = _apiProvider.getSignedApi();
    if(signedApi == null) return Future.error(StateError('No signed API instance found'));
    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if(accountId == null) return Future.error(StateError('No wallet info found'));

    return signedApi.blobs.create(blob, ownerAccountId: accountId).then((blob) => _cache[blob.id] = blob);
  }

  static const CACHE_SIZE = 20;
}
