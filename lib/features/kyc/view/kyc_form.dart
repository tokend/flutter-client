import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/kyc/logic/kyc_bloc.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/view/add_image.dart';
import 'package:flutter_template/utils/view/base_state.dart';
import 'package:flutter_template/utils/view/default_appbar.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:flutter_template/utils/view/models/name.dart';
import 'package:flutter_template/utils/view/models/string_field.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class KycForm extends StatefulWidget {
  @override
  _SetKycFormState createState() => _SetKycFormState();
}

class _SetKycFormState extends BaseState<KycForm>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<DefaultButtonState> _kycFormButtonKey =
      GlobalKey<DefaultButtonState>();

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    final screenSize = MediaQuery.of(context).size;
    var progress;

    return ProgressHUD(
      child: Builder(builder: (contextBuilder) {
        return BlocListener<KycBloc, KycState>(
            listener: (context, state) {
              progress = ProgressHUD.of(contextBuilder);
              if (state.status.isSubmissionInProgress) {
                progress.show();
              } else if (state.status.isInvalid) {
                updateValidationState(_kycFormButtonKey, false);
              } else if (state.status.isValid) {
                progress.dismiss();
                updateValidationState(_kycFormButtonKey, true);
              } else if (state.status.isSubmissionFailure) {
                progress.dismiss();
                print('submission failure');
              } else if (state.status.isSubmissionSuccess) {
                progress.dismiss();
                Get.toNamed('/signIn'); //TODO: change route
              }
            },
            child: Scaffold(
              appBar: DefaultAppBar(
                colorTheme: colorTheme,
                color: colorTheme.primaryText,
                title: "kyc_procedure_title".tr,
                onBackPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              body: SafeArea(
                  bottom: true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        children: [
                          Center(
                            child: _ImageInputField(),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _FirstNameInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _LastNameInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _NationalityInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _PhoneNumberInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _NationalInsuranceInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _TaxIdInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _IdentityCardNumberInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _HighestSchoolNumberInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _VocationTradingCertificateInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _AddressInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _SexInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _DateOfBirthInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _IbanInputField(),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Sizes.halfStandartPadding),
                          ),
                          _KycSubmitButton(_kycFormButtonKey)
                        ],
                      ),
                    ),
                  )),
            ));
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ImageInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.image != current.image,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: AddImageForm(
              key: const Key('kycForm_imageInput_profileImage'),
              imagePath: state.image.value == '' ? null : state.image.value,
              onChanged: (image) => context
                  .read<KycBloc>()
                  .add(ProfileImageChanged(image: image)),
            ));
      },
    );
  }
}

class _FirstNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'first_name_label'.tr,
            hint: 'first_name_hint'.tr,
            inputType: TextInputType.name,
            key: const Key('kycForm_firstNameInput_profileImage'),
            error: state.firstName.error != null
                ? state.firstName.error!.name
                : null,
            onChanged: (firstName) => context
                .read<KycBloc>()
                .add(FirstNameChanged(firstName: firstName)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _LastNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'last_name_label'.tr,
            hint: 'last_name_hint'.tr,
            inputType: TextInputType.name,
            key: const Key('kycForm_lastNameInput_profileImage'),
            error: state.lastName.error != null
                ? state.lastName.error!.name
                : null,
            onChanged: (lastName) => context
                .read<KycBloc>()
                .add(LastNameChanged(lastName: lastName)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _NationalityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.nationality != current.nationality,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'nationality_label'.tr,
            hint: 'nationality_hint'.tr,
            inputType: TextInputType.name,
            key: const Key('kycForm_nationalityInput_profileImage'),
            error: state.nationality.error != null
                ? state.nationality.error!.name
                : null,
            onChanged: (nationality) => context
                .read<KycBloc>()
                .add(NationalityChanged(nationality: nationality)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _PhoneNumberInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'phone_number_label'.tr,
            hint: 'phone_number_hint'.tr,
            inputType: TextInputType.phone,
            key: const Key('kycForm_phoneInput_profileImage'),
            error: state.phoneNumber.error != null
                ? state.phoneNumber.error!.name
                : null,
            onChanged: (phoneNumber) => context
                .read<KycBloc>()
                .add(PhoneNumberChanged(phoneNumber: phoneNumber)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _NationalInsuranceInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.nationalInsuranceNumber != current.nationalInsuranceNumber,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'national_insurance_number_label'.tr,
            hint: 'national_insurance_number_hint'.tr,
            key: const Key('signUpForm_nationalInsuranceInput_textField'),
            error: state.nationalInsuranceNumber.error != null
                ? state.nationalInsuranceNumber.error!.name
                : null,
            onChanged: (nationalInsuranceNumber) => context.read<KycBloc>().add(
                NationalInsuranceNumberChanged(
                    nationalInsuranceNumber: nationalInsuranceNumber)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _TaxIdInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.taxId != current.taxId,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'tax_id_label'.tr,
            hint: 'tax_id_hint'.tr,
            key: const Key('kycForm_taxIdInput_profileImage'),
            error: state.taxId.error != null ? state.taxId.error!.name : null,
            onChanged: (taxId) =>
                context.read<KycBloc>().add(TaxIdChanged(taxId: taxId)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _IdentityCardNumberInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.identityCardNumber != current.identityCardNumber,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'identity_card_number_label'.tr,
            hint: 'identity_card_number_hint'.tr,
            key: const Key('kycForm_identityCardInput_profileImage'),
            error: state.identityCardNumber.error != null
                ? state.identityCardNumber.error!.name
                : null,
            onChanged: (identityCardNumber) => context.read<KycBloc>().add(
                IdentityCardNumberChanged(
                    identityCardNumber: identityCardNumber)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _HighestSchoolNumberInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.highestSchoolNumber != current.highestSchoolNumber,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'highest_school_number_label'.tr,
            hint: 'highest_school_number_hint'.tr,
            key: const Key('kycForm_schoolNumberInput_profileImage'),
            error: state.highestSchoolNumber.error != null
                ? state.highestSchoolNumber.error!.name
                : null,
            onChanged: (highestSchoolNumber) => context.read<KycBloc>().add(
                HighestSchoolNumberChanged(
                    highestSchoolNumber: highestSchoolNumber)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _VocationTradingCertificateInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.vocationTrainingCertificate !=
          current.vocationTrainingCertificate,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'vocation_training_certificate_label'.tr,
            hint: 'vocation_training_certificate_hint'.tr,
            key: const Key('kycForm_vocationInput_profileImage'),
            error: state.vocationTrainingCertificate.error != null
                ? state.vocationTrainingCertificate.error!.name
                : null,
            onChanged: (vocationTrainingCertificate) => context
                .read<KycBloc>()
                .add(VocationTrainingCertificateChanged(
                    vocationTrainingCertificate: vocationTrainingCertificate)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _AddressInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.address != current.address,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'address_label'.tr,
            hint: 'address_hint'.tr,
            inputType: TextInputType.streetAddress,
            key: const Key('kycForm_addressInput_profileImage'),
            error:
                state.address.error != null ? state.address.error!.name : null,
            onChanged: (address) =>
                context.read<KycBloc>().add(AddressChanged(address: address)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _SexInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    var _currencies = [
      "Male",
      "Female",
    ];
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.sex != current.sex,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: DropDownField(
                colorTheme: colorTheme,
                hintText: "Hint",
                labelText: "Label",
                errorText: state.sex.error?.name,
                currentValue: state.sex.value,
                onChanged: (String? newValue) {
                  context.read<KycBloc>().add(SexChanged(sex: newValue));
                },
                list: _currencies));
      },
    );
  }
}

class _DateOfBirthInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'date_of_birth_label'.tr,
            hint: 'date_of_birth_hint'.tr,
            inputType: TextInputType.datetime,
            key: const Key('kycForm_dateOfBirthInput_profileImage'),
            error: state.dateOfBirth.error != null
                ? state.dateOfBirth.error!.name
                : null,
            onChanged: (dateOfBirth) => context
                .read<KycBloc>()
                .add(DateOfBirthChanged(dateOfBirth: dateOfBirth)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _IbanInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.iban != current.iban,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: DefaultTextField(
            label: 'iban_label'.tr,
            hint: 'iban_hint'.tr,
            key: const Key('kycForm_ibanInput_profileImage'),
            error: state.iban.error != null ? state.iban.error!.name : null,
            onChanged: (iban) =>
                context.read<KycBloc>().add(IbanChanged(iban: iban)),
            colorTheme: colorTheme,
          ),
        );
      },
    );
  }
}

class _KycSubmitButton extends StatelessWidget {
  GlobalKey? parentKey;

  _KycSubmitButton(this.parentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<KycBloc, KycState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return DefaultButton(
          defaultState: false,
          key: parentKey,
          text: 'action_continue'.tr,
          onPressed: () {
            state.status.isValidated
                ? context.read<KycBloc>().add(FormSubmitted())
                : null;
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}

updateValidationState(GlobalKey<DefaultButtonState> key, bool isFormValid) {
  (key.currentState as DefaultButtonState).setIsEnabled(isFormValid);
}
