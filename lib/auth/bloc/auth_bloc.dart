import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/auth/model/user_model.dart';

import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginButtonPressedEvent>(_login);
  }

  Future<void> _login(
      LoginButtonPressedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User user =
          await RepoProvider().getUser(event.username, event.password);
      print("user aayo ${user.username}");
   
      SharedPreferenecesService.setString(
          key: "currentUser", value: jsonEncode(user));
      emit(AuthSuccess(user: user));
    } catch (e) {
      log(e.toString());
      emit(AuthFailure(error: "wrong username or password"));
      print("error token aayo $e");
    }
  }
}
