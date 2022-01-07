part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState(
    this.email,
    this.password, {
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, confirmPassword, status];

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzStatus? status,
  }) {
    return SignUpState(
      email ?? this.email,
      password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }
}
