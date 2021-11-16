import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class OldPasswordChanged extends ChangePasswordEvent {
  const OldPasswordChanged(
    this.oldPassword,
  );

  final String? oldPassword;

  @override
  List<Object?> get props => [oldPassword];
}

class NewPasswordChanged extends ChangePasswordEvent {
  const NewPasswordChanged(
    this.newPassword,
  );

  final String? newPassword;

  @override
  List<Object?> get props => [newPassword];
}

class RepeatPasswordChanged extends ChangePasswordEvent {
  const RepeatPasswordChanged(
    this.repeatPassword,
  );

  final String? repeatPassword;

  @override
  List<Object?> get props => [repeatPassword];
}

class FormSubmitted extends ChangePasswordEvent {
  const FormSubmitted(
    this.oldPassword,
    this.newPassword,
    this.repeatPassword,
  );

  final String? oldPassword;
  final String? newPassword;
  final String? repeatPassword;

  @override
  List<Object?> get props => [oldPassword, newPassword, repeatPassword];
}
