import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/kyc/logic/kyc_bloc.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:flutter_template/utils/view/add_image.dart';
import 'package:flutter_template/utils/view/default_appbar.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class KycForm extends StatelessWidget {
  KycForm({Key? key}) : super(key: key);
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
                color: colorTheme.primaryText,
                title: "kyc_procedure_title".tr,
                onBackPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Center(
                      child: _ImageInputField(),
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }
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
              key: const Key('signUpForm_imageInput_profileImage'),
              imagePath: state.image.value == '' ? null : state.image.value,
              onChanged: (image) => context
                  .read<KycBloc>()
                  .add(ProfileImageChanged(image: image)),
            ));
      },
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  var _image = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 40.0,
              child: CircleAvatar(
                radius: 38.0,
                child: ClipOval(
                  child: (_image != null)
                      ? Image.file(_image)
                      : Icon(CustomIcons.camera_3_fill),
                ),
                backgroundColor: Colors.white,
              )),
        ));
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
