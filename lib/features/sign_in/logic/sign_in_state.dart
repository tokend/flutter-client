part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  SignInState(
    this.email,
    this.password, {
    this.network = '',
    this.status = FormzStatus.pure,
    this.error,
  });

  final String network;
  final Email email;
  final Password password;
  final FormzStatus status;
  Object? error;
  @override
  List<Object> get props => [network, email, password, status];

  SignInState copyWith({
    String? network,
    Email? email,
    Password? password,
    FormzStatus? status,
    Object? error,
  }) {
    return SignInState(
      email ?? this.email,
      password ?? this.password,
      network: network ?? this.network,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
