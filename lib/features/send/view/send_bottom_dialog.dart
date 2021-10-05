import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/send/bloc/send_bloc.dart';
import 'package:flutter_template/features/send/bloc/send_event.dart';
import 'package:flutter_template/features/send/bloc/send_state.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SendScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: BlocProvider(
        create: (_) => SendBloc(SendInitial()),
        child: SendBottomDialog(),
      ),
    ));
  }
}

class SendBottomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Builder(builder: (contextBuilder) {
      return Container(
          height: 730.0,
          color: contextBuilder.colorTheme.background,
          child: BlocListener<SendBloc, SendState>(
              listener: (context, state) {
                if (state.isRequestReady) {
                  showDialog(
                      context: buildContext,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('confirm_send_op'.tr),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: Text('cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                                context
                                    .read<SendBloc>()
                                    .add(RequestCreated(true));
                              }, //loader
                              child: Text('ok'.tr),
                            ),
                          ],
                        );
                      });
                } else if (state.error != null) {
                  log(state.error.toString());
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.standartPadding, vertical: 36.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'send_to'.tr,
                          style: TextStyle(
                              fontSize: 17.0,
                              color: buildContext.colorTheme.headerText),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.standartPadding),
                    ),
                    Row(
                      children: [
                        Text(
                          'asset'.tr,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: buildContext.colorTheme.accent),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    //TODO add dropdown
                    Row(
                      children: [
                        Text(
                          'Balance is 0 BTC.',
                          style: TextStyle(
                              color: buildContext.colorTheme.grayText,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.standartMargin),
                    ),
                    _AmountInputField(),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.standartMargin),
                    ),
                    _RecipientInputField(),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.standartMargin),
                    ),
                    _SendButton(),
                  ],
                ),
              )));
    });
  }
}

class _SendButton extends StatelessWidget {
  _SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return DefaultButton(
          text: 'action_continue'.tr,
          defaultState: false,
          onPressed: () {
            context.read<SendBloc>().add(FormFilled(true));
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}

class _RecipientInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return DefaultTextField(
          colorTheme: context.colorTheme,
          onChanged: (String newRecipient) {
            context.read<SendBloc>().add(RecipientChanged(newRecipient));
          },
          hint: 'recipient_acc_id_hint'.tr,
          label: 'recipient_acc_id'.tr,
        );
      },
    );
  }
}

class _AmountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return DefaultTextField(
          //Amount
          colorTheme: context.colorTheme,
          onChanged: (String newAmount) {
            context
                .read<SendBloc>()
                .add(AmountChanged(Decimal.parse(newAmount)));
          },
          inputType: TextInputType.number,
          hint: '0',
          label: 'amount'.tr,
        );
      },
    );
  }
}
