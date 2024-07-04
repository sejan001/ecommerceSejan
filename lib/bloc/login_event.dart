import 'package:equatable/equatable.dart';


abstract class LoginEvent extends Equatable{

  

  const LoginEvent();

}

class Username extends LoginEvent{
 final String username;
  Username({ required this.username
  });

  @override
  List<Object> get  props => [username];

}
class Password extends LoginEvent{
  final String password;
 Password({required this.password
  });
 @override
  List<Object> get  props => [password];
}
class LoginSumbitted extends LoginEvent{
  final String username;
  final String password;
  LoginSumbitted({required this.username,required this.password});
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
class LoginError{
  String? message;
  LoginError({this.message});


}