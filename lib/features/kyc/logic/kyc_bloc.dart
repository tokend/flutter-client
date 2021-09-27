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
  Stream<KycState> mapEventToState(
    KycEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
