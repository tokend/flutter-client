import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/assets/model/asset.dart';
import 'package:flutter_template/features/balances/model/balance_record.dart';
import 'package:flutter_template/features/send/bloc/send_bloc.dart';
import 'package:flutter_template/features/send/bloc/send_event.dart';
import 'package:flutter_template/features/send/bloc/send_state.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/formatters/decimal_text_input_formatter.dart';
import 'package:flutter_template/utils/view/counter_text_field.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SendScaffold extends StatelessWidget {
  List<BalanceRecord> balances;
  late List<Asset> assets;

  SendScaffold(this.balances) {
    this.assets = balances.map((balance) => balance.asset).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocProvider(
          create: (_) =>
              SendBloc(
                  SendInitial(
                      assets.first, balances.first, Decimal.zero, '', null)),
          child: SendBottomDialog(balances, assets),
        ));
  }
}

class SendBottomDialog extends BaseStatelessWidget {
  List<BalanceRecord> balances;
  List<Asset> assets;
  GlobalKey<DefaultButtonState> _sendButtonKey =
  GlobalKey<DefaultButtonState>();

  SendBottomDialog(this.balances, this.assets);

  @override
  Widget build(BuildContext buildContext) {
    var progress;

    return ProgressHUD(
      child: Builder(builder: (contextBuilder) {
        return Container(
            child: BlocListener<SendBloc, SendState>(
                listener: (context, state) {
                  updateValidationState(_sendButtonKey, state.recipient);
                  progress = ProgressHUD.of(contextBuilder);
                  if (state.error != null) {
                    progress.dismiss();
                  } else if (state.isRequestSubmitted) {
                    progress.dismiss();
                    repositoryProvider.balances.update();
                    Navigator.pop(contextBuilder, false);
                  } else if (state.isRequestConfirmed) {
                    progress.show();
                  } else if (state.isRequestReady) {
                    showDialog(
                        context: buildContext,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('confirm_send_op'.tr),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  progress.dismiss();
                                  Navigator.pop(dialogContext, false)
                                },
                                child: Text('cancel'.tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                  context
                                      .read<SendBloc>()
                                      .add(RequestConfirmed(true));
                                }, //loader
                                child: Text('ok'.tr)
                                ,
                              )
                              ,
                            ]
                            ,
                          );
                        });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.standartPadding, vertical: 36.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding:
                            EdgeInsets.only(top: Sizes.standartPadding),
                          ),
                          _BalanceDropDown(balances),
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
                          _NotesInputField(),
                          Padding(
                              padding:
                              EdgeInsets.only(top: Sizes.standartMargin)),
                        ],
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: _SendButton(_sendButtonKey),
                      )
                    ],
                  ),
                )));
      }),
    );
  }
}

class _SendButton extends StatelessWidget {
  GlobalKey? parentKey;

  _SendButton(this.parentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SendBloc, SendState>(
      buildWhen: (previous, current) => previous.recipient != current.recipient,
      builder: (context, state) {
        return DefaultButton(
          key: parentKey,
          text: 'action_continue'.tr,
          defaultState: true,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
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

class _AvailableBalanceField extends StatelessWidget {
  //TODO add info icon
  List<BalanceRecord> balances;

  _AvailableBalanceField(this.balances);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return Text(
          'Balance is ${getBalanceByAssetCode(balances, state.asset.code)
              .available} ${state.asset.code.toUpperCase()}.',
          style: TextStyle(color: context.colorTheme.grayText, fontSize: 12.0),
        );
      },
    );
  }
}

BalanceRecord getBalanceByAssetCode(List<BalanceRecord> balances,
    String assetCode) {
  try {
    return balances.firstWhere((element) => element.asset.code == assetCode);
  } catch (e, stacktrace) {
    print(stacktrace.toString());
    return balances.first;
  }
}

class _BalanceDropDown extends StatelessWidget {
  List<BalanceRecord> balances;

  _BalanceDropDown(this.balances);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: BalanceDropDownField(
                colorTheme: colorTheme,
                labelText: 'balance'.tr,
                currentValue: state.balanceRecord,
                onChanged: (BalanceRecord? newBalance) {
                  context.read<SendBloc>().add(BalanceChanged(newBalance));
                },
                list: balances));
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
          textInputFormatters: [DecimalTextInputFormatter()],
          colorTheme: context.colorTheme,
          onChanged: (String newAmount) {
            if (newAmount.isNotEmpty) {
              context
                  .read<SendBloc>()
                  .add(AmountChanged(Decimal.parse(newAmount)));
            } else {
              context.read<SendBloc>().add(AmountChanged(Decimal.zero)); //?
            }
          },
          inputType: TextInputType.number,
          hint: '0',
          label: 'amount'.tr,
        );
      },
    );
  }
}

class _NotesInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        return CounterTextField(
          colorTheme: context.colorTheme,
          onChanged: (String newNote) {
            context.read<SendBloc>().add(NoteChanged(newNote));
          },
          suffixText: '${state.notes.length} / 50',
          hint: 'note_hint'.tr,
        );
      },
    );
  }
}

updateValidationState(GlobalKey<DefaultButtonState> key, String recipient) {
  key.currentState?.setIsEnabled(recipient.isNotEmpty);
}
