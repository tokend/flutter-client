import 'package:equatable/equatable.dart';
import 'package:flutter_template/utils/view/models/confirm_password.dart';
import 'package:flutter_template/utils/view/models/password.dart';
import 'package:formz/formz.dart';

class ChangePasswordState extends Equatable {
  final Password oldPassword;
  final Password newPassword;
  final ConfirmPassword repeatPassword;
  final FormzStatus status;
  Object? error;

  ChangePasswordState(
      this.oldPassword, this.newPassword, this.repeatPassword, this.status,
      {this.error});

  @override
  List<Object?> get props => [oldPassword, newPassword, repeatPassword, status];

  ChangePasswordState copyWith({
    Password? oldPassword,
    Password? newPassword,
    ConfirmPassword? repeatPassword,
    FormzStatus? status,
    Object? error,
  }) {
    return ChangePasswordState(
      oldPassword ?? this.oldPassword,
      newPassword ?? this.newPassword,
      repeatPassword ?? this.repeatPassword,
      status ?? this.status,
      error: error ?? this.error,
    );
  }
}
