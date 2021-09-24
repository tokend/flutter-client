part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  SignInState({
    this.network = '',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
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
      network: network ?? this.network,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}
