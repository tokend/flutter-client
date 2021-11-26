import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:flutter_template/features/kyc/model/kyc_request_state.dart';

class KycRequestStateRepository extends SingleItemRepository<KycRequestState> {
  final TokenDApi api;
  final TokenDApi signedApi;
  final WalletInfo walletInfo;
  final BlobsRepository blobsRepository;
  final KeyValueEntriesRepository keyValueEntriesRepository;

  KycRequestStateRepository(this.api, this.signedApi, this.walletInfo,
      this.blobsRepository, this.keyValueEntriesRepository);

  @override
  Future<KycRequestState> getItem() {
    Int64 requestId = Int64(0);
    return Future.value();
  }

  //TODO: need to create ReviewableRequestResource
  void _getLastKycRequest(String accountId) {
    //TODO: need to add ChangeRoleRequestPageParams to DartSDK
    signedApi.v3.requests.getChangeRoleRequests(/*place PageParams here*/).then(
        (value) =>
            value /*.first()*/); // TODO: Тут должен быть List, но пока в сдк возвращается void
  }

  Future<KycForm> _loadKycFormFromBlob(String? blobId, Int64 roleId) {
    if (blobId == null) {
      return Future.value(EmptyKycForm());
    }

    try {
      return blobsRepository.getById(blobId, isPrivate: true).then((blob) =>
          keyValueEntriesRepository.update().then((_) => Future.value(
              KycForm.fromBlob(blob, roleId.toInt(),
                  keyValueEntriesRepository.entriesMap.values.toList()))));
    } catch (e) {
      return Future.value(EmptyKycForm());
    }
  }
}
