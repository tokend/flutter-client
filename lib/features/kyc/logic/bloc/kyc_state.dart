part of 'kyc_bloc.dart';

class KycState extends Equatable {
  const KycState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.nationality = const StringField.pure(isOptional: true),
    this.phoneNumber = const StringField.pure(isOptional: true),
    this.nationalInsuranceNumber = const StringField.pure(isOptional: true),
    this.taxId = const StringField.pure(isOptional: true),
    this.identityCardNumber = const StringField.pure(isOptional: true),
    this.highestSchoolNumber = const StringField.pure(isOptional: true),
    this.vocationTrainingCertificate = const StringField.pure(isOptional: true),
    this.address = const StringField.pure(isOptional: true),
    this.sex = const StringField.pure(isOptional: true),
    this.dateOfBirth = const StringField.pure(isOptional: true),
    this.iban = const StringField.pure(isOptional: true),
    this.image = const StringField.pure(),
    this.status = FormzStatus.pure,
  });

  final StringField image;
  final FirstName firstName;
  final LastName lastName;
  final StringField nationality;
  final StringField phoneNumber;
  final StringField nationalInsuranceNumber;
  final StringField taxId;
  final StringField identityCardNumber;
  final StringField highestSchoolNumber;
  final StringField vocationTrainingCertificate;
  final StringField address;
  final StringField sex;
  final StringField dateOfBirth;
  final StringField iban;
  final FormzStatus status;

  @override
  List<Object> get props => [
        image,
        firstName,
        lastName,
        nationality,
        phoneNumber,
        nationalInsuranceNumber,
        taxId,
        identityCardNumber,
        highestSchoolNumber,
        vocationTrainingCertificate,
        address,
        sex,
        dateOfBirth,
        iban,
        status
      ];

  KycState copyWith(
      {StringField? image,
      FirstName? firstName,
      LastName? lastName,
      StringField? nationality,
      StringField? phoneNumber,
      StringField? nationalInsuranceNumber,
      StringField? taxId,
      StringField? identityCardNumber,
      StringField? highestSchoolNumber,
      StringField? vocationTrainingCertificate,
      StringField? address,
      StringField? sex,
      StringField? dateOfBirth,
      StringField? iban,
      FormzStatus? status}) {
    return KycState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nationality: nationality ?? this.nationality,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalInsuranceNumber:
          nationalInsuranceNumber ?? this.nationalInsuranceNumber,
      taxId: taxId ?? this.taxId,
      identityCardNumber: identityCardNumber ?? this.identityCardNumber,
      highestSchoolNumber: highestSchoolNumber ?? this.highestSchoolNumber,
      vocationTrainingCertificate:
          vocationTrainingCertificate ?? this.vocationTrainingCertificate,
      address: address ?? this.address,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      iban: iban ?? this.iban,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }
}
