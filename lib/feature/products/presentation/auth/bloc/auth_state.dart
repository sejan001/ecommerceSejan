part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  var username;

  var Token;
  AuthSuccess({required this.username, required this.Token});
}

class AuthFailure extends AuthState {
  String error;

  AuthFailure({required this.error});
}
