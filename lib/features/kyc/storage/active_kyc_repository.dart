import 'dart:developer';

import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/features/account/model/account_record.dart';
import 'package:flutter_template/features/account/storage/account_repository.dart';
import 'package:flutter_template/features/blobs/blobs_repository.dart';
import 'package:flutter_template/features/kyc/model/active_kyc.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';

class ActiveKycRepository extends SingleItemRepository<ActiveKyc> {
  AccountRepository _accountRepository;
  BlobsRepository _blobsRepository;
  ObjectPersistence<ActiveKyc> persistence;

  ActiveKycRepository(
      this._accountRepository, this._blobsRepository, this.persistence);

  @override
  Future<ActiveKyc> getItem() async {
    var kyc = _accountRepository.getItem().then((account) async {
      if (account.kycBlob != null) {
        var form = await getForm(account.kycBlob!);
        return ActiveKycForm(form);
      }
      return Future.value(KycMissing());
    });

    streamSubject.sink.add(await kyc);
    return kyc;
  }

  Future<AccountRecord?> getAccount() {
    return _accountRepository.getItem().then((_) => _accountRepository.item);
  }

  Future<KycForm> getForm(
    String blobId,
  ) {
    return _blobsRepository.getById(blobId, isPrivate: true).then((blob) {
      return GeneralKycForm(firstName: 'Toma', lastName: 'Gambarova'); //TODO
    });
  }
}
