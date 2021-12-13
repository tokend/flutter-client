part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  SignInState(
    this.email,
    this.password, {
    this.network = '',
    this.hasKyc = false,
    this.status = FormzStatus.pure,
    this.error,
  });

  final String network;
  final Email email;
  final Password password;
  final FormzStatus status;
  final bool hasKyc;
  Object? error;

  @override
  List<Object> get props => [network, email, password, status, hasKyc];

  SignInState copyWith({
    String? network,
    Email? email,
    Password? password,
    FormzStatus? status,
    bool? hasKyc,
    Object? error,
  }) {
    return SignInState(
      email ?? this.email,
      password ?? this.password,
      network: network ?? this.network,
      status: status ?? this.status,
      hasKyc: hasKyc ?? this.hasKyc,
      error: error ?? this.error,
    );
  }
}
