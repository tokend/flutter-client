import 'package:flutter_template/base/base_bloc.dart';

import 'create_offer_event.dart';
import 'create_offer_state.dart';

class CreateOfferBloc extends BaseBloc<CreateOfferEvent, CreateOfferState> {
  CreateOfferBloc(CreateOfferState initialState) : super(initialState);

  @override
  Stream<CreateOfferState> mapEventToState(CreateOfferEvent event) async* {
    if (event is AmountChanged) {
      yield state.copyWith(amount: event.amount);
    } else if (event is PriceChanged) {
      yield state.copyWith(price: event.price);
    } else if (event is AssetChanged) {
      yield state.copyWith(asset: event.asset);
    } else if (event is IsBuyChanged) {
      yield state.copyWith(isBuy: event.isBuy);
    } else if (event is FormFilled) {
      //TODO
    } else if (event is RequestConfirmed) {

    }
  }
}
