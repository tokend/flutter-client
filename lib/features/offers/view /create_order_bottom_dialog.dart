import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_template/base/base_widget.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/features/offers/bloc/create_offer_bloc.dart';
import 'package:flutter_template/features/offers/bloc/create_offer_event.dart';
import 'package:flutter_template/features/offers/bloc/create_offer_state.dart';
import 'package:flutter_template/features/offers/view%20/offer_type_picker.dart';
import 'package:flutter_template/features/trade%20/pairs/asset_pair_record.dart';
import 'package:flutter_template/resources/sizes.dart';
import 'package:flutter_template/utils/formatters/decimal_text_input_formatter.dart';
import 'package:flutter_template/utils/view/default_button_state.dart';
import 'package:flutter_template/utils/view/default_text_field.dart';
import 'package:flutter_template/utils/view/drop_down_field.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CreateOrderScaffold extends StatelessWidget {
  List<AssetPairRecord> assetPairs;

  CreateOrderScaffold(this.assetPairs);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (_) => CreateOfferBloc(CreateOfferState(
          amount: Decimal.zero,
          isBuy: true,
          assetPairRecord: assetPairs.first,
          price: Decimal.zero,
        )),
        child: CreateOrderBottomDialog(assetPairs),
      ),
    );
  }
}

int selectedOfferType = 0;

class CreateOrderBottomDialog extends BaseStatefulWidget {
  List<AssetPairRecord> assetPairs;

  CreateOrderBottomDialog(this.assetPairs);

  @override
  State<CreateOrderBottomDialog> createState() =>
      _CreateOrderBottomDialogState(assetPairs);
}

class _CreateOrderBottomDialogState extends State<CreateOrderBottomDialog> {
  List<AssetPairRecord> assetPairs;

  _CreateOrderBottomDialogState(this.assetPairs);

  GlobalKey<DefaultButtonState> _createButtonKey =
      GlobalKey<DefaultButtonState>();

  List<String> buttonLabels =
      List.of(['create_buy_order'.tr, 'create_sell_order'.tr]);

  @override
  Widget build(BuildContext buildContext) {
    var progress;

    return ProgressHUD(child: Builder(builder: (contextBuilder) {
      return Container(
        child: BlocListener<CreateOfferBloc, CreateOfferState>(
          listener: (context, state) {
            progress = ProgressHUD.of(contextBuilder);

            if (state.error != null) {
              progress.dismiss();
            } else if (state.isRequestSubmitted) {
              progress.dismiss();
              widget.repositoryProvider.offersRepository.update();
              Navigator.pop(contextBuilder, false);
            } else if (state.isRequestConfirmed) {
              progress.show();
            } else if (state.isRequestReady) {
              showDialog(
                  context: buildContext,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('confirm_offer_creation_op'.tr),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text('cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                            context
                                .read<CreateOfferBloc>()
                                .add(RequestConfirmed(true));
                          }, //loader
                          child: Text('ok'.tr),
                        ),
                      ],
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
                          'create_order'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                              color: buildContext.colorTheme.headerText),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.standartPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: new BoxConstraints(
                              maxHeight: 45.0,
                            ),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        GestureDetector(
                                      onTap: () {
                                        context
                                            .read<CreateOfferBloc>()
                                            .add(IsBuyChanged(index == 0));
                                        setState(() {
                                          selectedOfferType = index;
                                        });
                                      },
                                      child: Container(
                                        child: OfferTypePickerItem(
                                            buttonLabels[index],
                                            selectedOfferType == index),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartPadding)),
                    _BaseAssetTextField(assetPairs),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin)),
                    _PriceInputField(),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin)),
                    _AmountInputField(),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartPadding)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'order_fee'.tr,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: buildContext.colorTheme.lightGrayText),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '0 USD',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: buildContext.colorTheme.primaryText),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: Sizes.quartedStandartMargin)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //TODO navigate to Fees page
                          },
                          child: Text(
                            'show_account_fees'.tr,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: buildContext.colorTheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: Sizes.standartMargin)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total_amount'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                              color: buildContext.colorTheme.grayText),
                          textAlign: TextAlign.left,
                        ),
                        _TotalField(),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _CreateButton(_createButtonKey),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}

class _BaseAssetTextField extends StatelessWidget {
  List<AssetPairRecord> assetPairs;

  _BaseAssetTextField(this.assetPairs);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
        builder: (context, state) {
      var colorScheme = context.colorTheme;

      return DropDownField<AssetPairRecord>(
        onChanged: (newPair) {
          context.read<CreateOfferBloc>().add(AssetPairChanged(newPair));
        },
        colorTheme: colorScheme,
        currentValue: state.assetPairRecord,
        list: assetPairs,
        format: (AssetPairRecord item) {
          return '${item.base.code}/${item.quote.code}';
        },
      );
    });
  }
}

class _AmountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      builder: (context, state) {
        return DefaultTextField(
          textInputFormatters: [DecimalTextInputFormatter()],
          colorTheme: context.colorTheme,
          onChanged: (String newAmount) {
            if (newAmount.isNotEmpty) {
              context
                  .read<CreateOfferBloc>()
                  .add(AmountChanged(Decimal.parse(newAmount)));
            } else {
              context.read<CreateOfferBloc>().add(AmountChanged(Decimal.zero));
            }
          },
          inputType: TextInputType.number,
          hint: '0',
          label: 'amount'.tr + 'of ${state.assetPairRecord.base.code}',
        );
      },
    );
  }
}

class _PriceInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      builder: (context, state) {
        return DefaultTextField(
          textInputFormatters: [DecimalTextInputFormatter()],
          colorTheme: context.colorTheme,
          onChanged: (String newPrice) {
            if (newPrice.isNotEmpty) {
              context
                  .read<CreateOfferBloc>()
                  .add(PriceChanged(Decimal.parse(newPrice)));
            } else {
              context.read<CreateOfferBloc>().add(PriceChanged(Decimal.zero));
            }
          },
          inputType: TextInputType.number,
          hint: '0',
          label: 'price'.tr +
              state.assetPairRecord.base.code +
              '(in ${state.assetPairRecord.quote.code})',
        );
      },
    );
  }
}

class _TotalField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      builder: (context, state) {
        return Text(
          '${state.isBuy || state.price == Decimal.zero || state.amount == Decimal.zero ? state.amount * state.price : state.price / state.amount} USD', //TODO
          style: TextStyle(
            fontSize: 20.0,
            color: context.colorTheme.primaryText,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }
}

class _CreateButton extends StatelessWidget {
  GlobalKey? parentKey;

  _CreateButton(this.parentKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    return BlocBuilder<CreateOfferBloc, CreateOfferState>(
      buildWhen: (previous, current) => previous.amount != current.amount,
      builder: (context, state) {
        return DefaultButton(
          key: parentKey,
          text: selectedOfferType == 0 ? 'buy'.tr : 'sell'.tr,
          defaultState: true,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            context.read<CreateOfferBloc>().add(FormFilled(true));
          },
          colorTheme: colorTheme,
        );
      },
    );
  }
}
