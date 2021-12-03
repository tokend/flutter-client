import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/api/v3/requests/model/request_model.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/di/providers/wallet_info_provider.dart';
import 'package:flutter_template/features/account/model/resolved_account_role.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/key_value/storage/key_value_entries_repository.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:flutter_template/features/kyc/model/kyc_request_state.dart';

class KycRequestStateRepository extends SingleItemRepository<KycRequestState> {
  final ApiProvider _apiProvider;
  final WalletInfoProvider _walletInfoProvider;
  final BlobsRepository _blobsRepository;
  final KeyValueEntriesRepository _keyValueEntriesRepository;

  KycRequestStateRepository(this._apiProvider, this._walletInfoProvider,
      this._blobsRepository, this._keyValueEntriesRepository);

  @override
  Future<KycRequestState> getItem() {
    var signedApi = _apiProvider.getSignedApi();
    if (signedApi == null)
      return Future.error(StateError('No signed API instance found'));

    var accountId = _walletInfoProvider.getWalletInfo()?.accountId;
    if (accountId == null)
      return Future.error(StateError('No wallet info found'));

    _getLastKycRequest(signedApi, accountId)
        .then((response) => print(response));

    var requestId = 0;

    return Future.value();
  }

  //TODO: need to create ReviewableRequestResource
  Future<Map<String, dynamic>> _getLastKycRequest(
      TokenDApi signedApi, String accountId) {
    return signedApi.v3.requests
        .getChangeRoleRequests(/*place PageParams here*/)
        .then((value) =>
            value /*.first()*/); // TODO: Тут должен быть List, но пока в сдк возвращается void
  }

  Future<KycForm> _loadKycFormFromBlob(String? blobId, Int64 roleId) {
    if (blobId == null) {
      return Future.value(EmptyKycForm());
    }

    try {
      return _blobsRepository.getById(blobId, isPrivate: true).then((blob) =>
          _keyValueEntriesRepository.update().then((_) => Future.value(
              KycForm.fromBlob(blob, roleId.toInt(),
                  _keyValueEntriesRepository.entriesMap.values.toList()))));
    } catch (e) {
      return Future.value(EmptyKycForm());
    }
  }
}

class FinalComposite {
  RequestState state;
  String? rejectReason;
  String? blockReason;
  KycForm kycForm;
  ResolvedAccountRole roleToSet;

  FinalComposite(this.state, this.rejectReason, this.blockReason, this.kycForm,
      this.roleToSet);
}
