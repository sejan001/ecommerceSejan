import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  const LoginState();
}
class LoginInitial extends LoginState{
  @override

  List<Object?> get props => throw UnimplementedError();

}
class LoginLoading extends LoginState{
  @override

  List<Object?> get props => throw UnimplementedError();

}

class LoginSuccessfulState extends LoginState{
  @override
 
  List<Object?> get props => throw UnimplementedError();

}
class LoginErrorState extends LoginState{
  final String? error;
  const LoginErrorState({required this.error});

  @override

  List<Object?> get props => throw UnimplementedError();

}