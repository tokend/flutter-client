import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_event.dart';
import 'package:flutter_template/features/change_password/bloc/change_password_state.dart';

class ChangePasswordBloc
    extends BaseBloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(initialState) : super(initialState);
}
