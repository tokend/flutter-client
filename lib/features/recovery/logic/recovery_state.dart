part of 'recovery_bloc.dart';

class RecoveryState extends Equatable {
  const RecoveryState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, confirmPassword, status];

  RecoveryState copyWith({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzStatus? status,
  }) {
    return RecoveryState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }
}

class RecoveryInitial extends RecoveryState {
  @override
  List<Object> get props => [];
}
