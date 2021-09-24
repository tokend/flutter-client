part of 'recovery_bloc.dart';

abstract class RecoveryEvent extends Equatable {
  const RecoveryEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends RecoveryEvent {
  const EmailChanged({
    required this.email,
  });

  final String? email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RecoveryEvent {
  const PasswordChanged({required this.password});

  final String? password;

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends RecoveryEvent {
  const ConfirmPasswordChanged({
    required this.confirmPassword,
  });

  final String? confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

class FormSubmitted extends RecoveryEvent {}
