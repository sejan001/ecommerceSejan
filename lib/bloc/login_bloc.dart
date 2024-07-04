import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc/bloc/login_event.dart';
import 'package:project_bloc/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String? username;
  String? password;

  LoginBloc() : super(LoginInitial()) {
    on<Username>((event, emit) {
      username = event.username;
      print("Username: $username");
    });

    on<Password>((event, emit) {
      password = event.password;
      print("Password: $password");
    });

    on<LoginSumbitted>((event, emit) async {
      emit(LoginLoading());
      try {
        if (username == "sejan" && password == "sejan") {
          emit(LoginSuccessfulState());
        } else {
          emit(LoginErrorState(error: 'Wrong username or password'));
        } 
      } catch (e) {
        print("Error occurred: $e");
        emit(LoginErrorState(error: 'An error occurred'));
      }
    });
  }
}
 