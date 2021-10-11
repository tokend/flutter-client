part of 'kyc_bloc.dart';

abstract class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object?> get props => [];
}

class ProfileImageChanged extends KycEvent {
  const ProfileImageChanged({@required this.image});

  final String? image;

  @override
  List<Object?> get props => [image];
}

class FirstNameChanged extends KycEvent {
  const FirstNameChanged({required this.firstName});

  final String? firstName;

  @override
  List<Object?> get props => [firstName];
}

class LastNameChanged extends KycEvent {
  const LastNameChanged({
    @required this.lastName,
  });

  final String? lastName;

  @override
  List<Object?> get props => [lastName];
}

class NationalityChanged extends KycEvent {
  const NationalityChanged({
    @required this.nationality,
  });

  final String? nationality;

  @override
  List<Object?> get props => [nationality];
}

class PhoneNumberChanged extends KycEvent {
  const PhoneNumberChanged({
    @required this.phoneNumber,
  });

  final String? phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

class NationalInsuranceNumberChanged extends KycEvent {
  const NationalInsuranceNumberChanged({
    @required this.nationalInsuranceNumber,
  });

  final String? nationalInsuranceNumber;

  @override
  List<Object?> get props => [nationalInsuranceNumber];
}

class TaxIdChanged extends KycEvent {
  const TaxIdChanged({
    @required this.taxId,
  });

  final String? taxId;

  @override
  List<Object?> get props => [taxId];
}

class IdentityCardNumberChanged extends KycEvent {
  const IdentityCardNumberChanged({
    @required this.identityCardNumber,
  });

  final String? identityCardNumber;

  @override
  List<Object?> get props => [identityCardNumber];
}

class HighestSchoolNumberChanged extends KycEvent {
  const HighestSchoolNumberChanged({
    @required this.highestSchoolNumber,
  });

  final String? highestSchoolNumber;

  @override
  List<Object?> get props => [highestSchoolNumber];
}

class VocationTrainingCertificateChanged extends KycEvent {
  const VocationTrainingCertificateChanged({
    @required this.vocationTrainingCertificate,
  });

  final String? vocationTrainingCertificate;

  @override
  List<Object?> get props => [vocationTrainingCertificate];
}

class AddressChanged extends KycEvent {
  const AddressChanged({
    @required this.address,
  });

  final String? address;

  @override
  List<Object?> get props => [address];
}

class SexChanged extends KycEvent {
  const SexChanged({
    @required this.sex,
  });

  final String? sex;

  @override
  List<Object?> get props => [sex];
}

class DateOfBirthChanged extends KycEvent {
  const DateOfBirthChanged({
    @required this.dateOfBirth,
  });

  final String? dateOfBirth;

  @override
  List<Object?> get props => [dateOfBirth];
}

class IbanChanged extends KycEvent {
  const IbanChanged({
    @required this.iban,
  });

  final String? iban;

  @override
  List<Object?> get props => [iban];
}

class FormSubmitted extends KycEvent {}
