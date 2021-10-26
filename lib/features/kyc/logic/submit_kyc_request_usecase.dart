import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:flutter_template/utils/file/local_file.dart';

class SubmitKycRequestUseCase {
  final KycForm kycForm;
  final KeyServer keyServer;
  final WalletInfo walletInfo;
  final TokenDApi api;
  final TokenDApi signedApi;
  final Map<String, RemoteFile>? alreadySubmittedDocuments;
  final Map<String, LocalFile>? newDocument;
  final int requestIdToSubmit;
  final int? explicitRoleToSet;

  SubmitKycRequestUseCase({required this.kycForm,
    required this.keyServer,
    required this.walletInfo,
    required this.api,
    required this.signedApi,
    this.alreadySubmittedDocuments,
    this.newDocument,
    this.requestIdToSubmit = 0,
    this.explicitRoleToSet});

  int _roleToSet = 0;
  late String _formBlobId;
  late NetworkParams _networkParams;
  late String _transactionRequestXdr;

  Future<void>? perform() {
    return null;
  }

  Future<int> _getRoleToSet() {
    if (explicitRoleToSet != null && explicitRoleToSet! > 0) {
      return Future.value(explicitRoleToSet);
    }

    var key = kycForm.getRoleKey();

    return Future.value(0); //TODO implement getting role from keyserver!!!!!
  }

  Future<NetworkParams> _getNetworkParams() {
    return api.v3
    .
  }

  Future<Map<String, RemoteFile>> uploadNewDocuments() async {
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
