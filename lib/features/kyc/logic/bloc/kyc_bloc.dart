import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/signing/account_request_signer.dart';
import 'package:dart_wallet/account.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/features/kyc/logic/submit_kyc_request_usecase.dart';
import 'package:flutter_template/features/kyc/model/kyc_form.dart';
import 'package:flutter_template/utils/file/local_file.dart';
import 'package:flutter_template/utils/view/models/name.dart';
import 'package:flutter_template/utils/view/models/string_field.dart';
import 'package:formz/formz.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends BaseBloc<KycEvent, KycState> {
  KycBloc(this.env) : super(KycState());
  Env env;

  @override
  void onTransition(Transition<KycEvent, KycState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<KycState> mapEventToState(
    KycEvent event,
  ) async* {
    if (event is ProfileImageChanged) {
      final profileImage = StringField.dirty(value: event.image!);
      yield state.copyWith(
        image: profileImage,
        status: Formz.validate([
          profileImage,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is FirstNameChanged) {
      final firstName = FirstName.dirty(event.firstName!);
      yield state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          state.image,
          firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is LastNameChanged) {
      final lastName = LastName.dirty(event.lastName!);
      yield state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          state.image,
          state.firstName,
          lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is NationalityChanged) {
      final nationality =
          StringField.dirty(value: event.nationality!, isOptional: true);
      yield state.copyWith(
        nationality: nationality,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is PhoneNumberChanged) {
      final phoneNumber =
          StringField.dirty(value: event.phoneNumber!, isOptional: true);
      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is NationalInsuranceNumberChanged) {
      final nationalInsuranceNumber = StringField.dirty(
          value: event.nationalInsuranceNumber!, isOptional: true);
      yield state.copyWith(
        nationalInsuranceNumber: nationalInsuranceNumber,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is TaxIdChanged) {
      final taxId = StringField.dirty(value: event.taxId!, isOptional: true);
      yield state.copyWith(
        taxId: taxId,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is IdentityCardNumberChanged) {
      final identityCardNumber =
          StringField.dirty(value: event.identityCardNumber!, isOptional: true);
      yield state.copyWith(
        identityCardNumber: identityCardNumber,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is HighestSchoolNumberChanged) {
      final highestSchoolNumber = StringField.dirty(
          value: event.highestSchoolNumber!, isOptional: true);
      yield state.copyWith(
        highestSchoolNumber: highestSchoolNumber,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is VocationTrainingCertificateChanged) {
      final vocationTrainingCertificate = StringField.dirty(
          value: event.vocationTrainingCertificate!, isOptional: true);
      yield state.copyWith(
        vocationTrainingCertificate: vocationTrainingCertificate,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is AddressChanged) {
      final address =
          StringField.dirty(value: event.address!, isOptional: true);
      yield state.copyWith(
        address: address,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          address,
          state.sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is SexChanged) {
      final sex = StringField.dirty(value: event.sex!, isOptional: true);
      yield state.copyWith(
        sex: sex,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          sex,
          state.dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is DateOfBirthChanged) {
      final dateOfBirth =
          StringField.dirty(value: event.dateOfBirth!, isOptional: true);
      yield state.copyWith(
        dateOfBirth: dateOfBirth,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          dateOfBirth,
          state.iban
        ]),
      );
    } else if (event is IbanChanged) {
      final iban = StringField.dirty(value: event.iban!, isOptional: true);
      yield state.copyWith(
        iban: iban,
        status: Formz.validate([
          state.image,
          state.firstName,
          state.lastName,
          state.nationality,
          state.phoneNumber,
          state.nationalInsuranceNumber,
          state.taxId,
          state.identityCardNumber,
          state.highestSchoolNumber,
          state.vocationTrainingCertificate,
          state.address,
          state.sex,
          state.dateOfBirth,
          iban
        ]),
      );
    } else if (event is FormSubmitted) {
      if (!state.status.isValidated) return;
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        var api = apiProvider.getApi();

        // var walletInfo = walletInfoProvider;
        var keyServer = KeyServer(api.wallets);
        var walletInfo =
            await keyServer.getWalletInfo("user1@gmail.com", "111111");
        var account =
            await Account.fromSecretSeed(walletInfo.secretSeeds.first);
        session.accountProvider.setAccount(account);
        var signedApi = TokenDApi("http://c663-193-19-228-94.ngrok.io/_/api/",
            requestSigner: AccountRequestSigner(account), tfaCallback: null);
        var result = await SubmitKycRequestUseCase(
            kycForm: GeneralKycForm(
                lastName: 'ksdjfg', firstName: 'skdjfh', document: null),
            accountProvider: session.accountProvider,
            txManager: txManager,
            keyServer: keyServer,
            walletInfo: walletInfo,
            api: api,
            keyValueEntriesRepository: keyValueEntriesRepository,
            signedApi: signedApi,
            repositoryProvider: repositoryProvider,
            newDocument: {
              "kyc_avatar": LocalFile.fromPath(state.image.value)
            }).perform();
        print("result");
      } on Exception {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}
