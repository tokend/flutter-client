import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/utils/view/models/name.dart';
import 'package:flutter_template/utils/view/models/string_field.dart';
import 'package:formz/formz.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  KycBloc() : super(KycState());

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
      final profileImage = StringField.dirty(event.image!);
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
      final nationality = StringField.dirty(event.nationality!);
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
      final phoneNumber = StringField.dirty(event.phoneNumber!);
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
      final nationalInsuranceNumber =
          StringField.dirty(event.nationalInsuranceNumber!);
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
      final taxId = StringField.dirty(event.taxId!);
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
      final identityCardNumber = StringField.dirty(event.identityCardNumber!);
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
      final highestSchoolNumber = StringField.dirty(event.highestSchoolNumber!);
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
      final vocationTrainingCertificate =
          StringField.dirty(event.vocationTrainingCertificate!);
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
      final address = StringField.dirty(event.address!);
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
      final sex = StringField.dirty(event.sex!);
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
      final dateOfBirth = StringField.dirty(event.dateOfBirth!);
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
      final iban = StringField.dirty(event.iban!);
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
      Future.delayed(Duration(seconds: 3));
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}
