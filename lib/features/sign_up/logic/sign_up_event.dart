part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends SignUpEvent {
  const EmailChanged({
    @required this.email,
  });

  final String? email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignUpEvent {
  const PasswordChanged({required this.password});

  final String? password;

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends SignUpEvent {
  const ConfirmPasswordChanged({
    @required this.confirmPassword,
  });

  final String? confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

class FormSubmitted extends SignUpEvent {}
