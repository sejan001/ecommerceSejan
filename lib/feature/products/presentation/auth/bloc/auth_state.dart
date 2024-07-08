part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  User user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  String error;

  AuthFailure({required this.error});
}
