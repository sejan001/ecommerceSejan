part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressedEvent extends AuthEvent {
  var username;
  var password;
  LoginButtonPressedEvent({required this.username, required this.password});
}
