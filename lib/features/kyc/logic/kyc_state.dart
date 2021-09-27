part of 'kyc_bloc.dart';

class KycState extends Equatable {
  const KycState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.nationality = const StringField.pure(),
    this.phoneNumber = "",
    this.nationalInsuranceNumber = const StringField.pure(),
    this.taxId = const StringField.pure(),
    this.identityCardNumber = const StringField.pure(),
    this.highestSchoolNumber = const StringField.pure(),
    this.vocationTrainingCertificate = const StringField.pure(),
    this.address = const StringField.pure(),
    this.sex = const StringField.pure(),
    this.dateOfBirth = const StringField.pure(),
    this.iban = const StringField.pure(),
    this.image = "",
    this.status = FormzStatus.pure,
  });

  final String image;
  final FirstName firstName;
  final LastName lastName;
  final StringField nationality;
  final String phoneNumber;
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
      {String? image,
      FirstName? firstName,
      LastName? lastName,
      StringField? nationality,
      String? phoneNumber,
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
