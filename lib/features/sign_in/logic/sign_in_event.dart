part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class NetworkChanged extends SignInEvent {
  const NetworkChanged(
    this.network,
  );

  final String? network;

  @override
  List<Object?> get props => [network];
}

class EmailChanged extends SignInEvent {
  const EmailChanged(
    this.email,
  );

  final String? email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignInEvent {
  const PasswordChanged({required this.password});

  final String? password;

  @override
  List<Object?> get props => [password];
}

class NotFirstLogIn extends SignInEvent {
  const NotFirstLogIn({required this.email, required this.password});

  final String? email;
  final Future<String?> password;

  @override
  List<Object?> get props => [email, password];
}

class FormSubmitted extends SignInEvent {}
