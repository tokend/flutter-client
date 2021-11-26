import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:dart_sdk/api/blobs/model/blob_type.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction.dart' as tr;
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_template/di/providers/account_provider.dart';
import 'package:flutter_template/di/providers/repository_provider.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:flutter_template/logic/tx_manager.dart';
import 'package:flutter_template/utils/file/local_file.dart';

class SubmitKycRequestUseCase {
  final KycForm kycForm;
  final KeyServer keyServer;
  final WalletInfo walletInfo;
  final TokenDApi api;
  final TokenDApi signedApi;
  final TxManager txManager;
  final AccountProvider accountProvider;
  final RepositoryProvider repositoryProvider;
  final Map<String, RemoteFile>? alreadySubmittedDocuments;
  final Map<String, LocalFile>? newDocument;
  final Int64? requestIdToSubmit;
  final Int64? explicitRoleToSet;

  SubmitKycRequestUseCase(
      {required this.kycForm,
      required this.keyServer,
      required this.walletInfo,
      required this.api,
      required this.signedApi,
      required this.repositoryProvider,
      required this.accountProvider,
      required this.txManager,
      this.alreadySubmittedDocuments,
      this.newDocument,
      this.requestIdToSubmit,
      this.explicitRoleToSet});

  Int64 _roleToSet = Int64(0);
  late String _formBlobId;
  late NetworkParams _networkParams;
  late String _transactionRequestXdr;
  late Map<String, RemoteFile> uploadedDocuments;

  Future<void>? perform() {
    _getRoleToSet()
        .then((role) => this._roleToSet = role)
        .then((_) => _uploadNewDocuments())
        .then((uploadedDocuments) => this.uploadedDocuments = uploadedDocuments)
        .then((_) => _uploadFormAsBlob())
        .then((formBlobId) => this._formBlobId = formBlobId)
        .then((_) => _getNetworkParams())
        .then((networkParams) => this._networkParams = networkParams)
        .then((_) => _getTransaction())
        .then((transaction) => txManager.submit(transaction))
        .then((response) =>
            this._transactionRequestXdr = response!.resultMetaXdr!);
  }

  Future<Int64> _getRoleToSet() {
    if (explicitRoleToSet != null && explicitRoleToSet! > 0) {
      return Future.value(explicitRoleToSet ?? Int64(0));
    }

    var key = kycForm.getRoleKey();

    return Future.value(
        Int64(0)); //TODO implement getting role from keyserver!!!!!
  }

  Future<NetworkParams> _getNetworkParams() {
    return repositoryProvider.systemInfo
        .getItem()
        .then((value) => value.toNetworkParams());
  }

  Future<String> _uploadFormAsBlob() {
    (kycForm as GeneralKycForm).document = {}
      ..addAll(alreadySubmittedDocuments ?? {})
      ..addAll(uploadedDocuments);

    var formJson = (kycForm as GeneralKycForm).toJson();

    return repositoryProvider.blobs
        .create(Blob.fromContent(
            BlobType.KYC_FORM,
            formJson
                .toString())) //TODO: check if map.toString() works correctly!
        .then((value) => value.id);
  }

  Future<tr.Transaction> _getTransaction() async {
    try {
      var operation = CreateChangeRoleRequestOp(
          requestIdToSubmit ?? Int64(0),
          PublicKeyFactory.fromAccountId(walletInfo.accountId),
          _roleToSet,
          "{\"blob_id\":\"$_formBlobId\"}",
          null,
          CreateChangeRoleRequestOpExtEmptyVersion());

      var transaction = await TransactionBuilder.FromPubKey(
              _networkParams, walletInfo.accountId)
          .addOperation(OperationBodyCreateChangeRoleRequest(operation))
          .build();

      var account = accountProvider.getAccount();
      if (account == null) {
        return Future.error(StateError('Cannot obtain current account'));
      }

      await transaction.addSignature(account);

      return Future.value(transaction);
    } catch (e, s) {
      log(s.toString());
      throw e;
    }
  }

  Future<Map<String, RemoteFile>> _uploadNewDocuments() async {
    if (this.newDocument == null) {
      return Future.value({});
    }
    List<Future<RemoteFile>> futureList = [];
    this.newDocument?.map((key, value) {
      var documentType;
      DocumentType.values.forEach((element) {
        documentType = element.toString().toLowerCase() == key.toLowerCase()
            ? element
            : DocumentType.GENERAL_PUBLIC;
      });
      futureList.add(_uploadFile(documentType, value));
      return MapEntry(key, value);
    });

    List<RemoteFile> remoteFilesList = await Future.wait(futureList);
    Map<String, RemoteFile> uploadedDocuments = {};
    var keysList = this.newDocument?.keys;
    print(keysList);
    Map<String, RemoteFile> resultMap =
        IterableZip<dynamic>([keysList!, remoteFilesList])
            .map((value) => {value[0] as String: value[1] as RemoteFile})
            .first;
    return Future.value(resultMap);
  }

  Future<RemoteFile> _uploadFile(DocumentType documentType,
      LocalFile localFile) async {
    Uint8List document = File(localFile.path).readAsBytesSync();

    var policy = await signedApi.documents
        .requestUpload(walletInfo.accountId, documentType, localFile.mimeType);
    return api.documents
        .upload(policy, localFile.mimeType, localFile.name, document);
  }
}
