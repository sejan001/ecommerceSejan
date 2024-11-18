import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/auth/model/complex_user_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filter_users_state.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<FetchUsers>(loadUsers);
  }

  Future<void> loadUsers(FetchUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      UserModel users = await RepoProvider().fetchUsers(model: event.model);
      emit(UsersLoadedState(users: users));
      print("Users loaded: ${users}");
    } catch (e) {
      emit(UserLoadingError(message: e.toString()));
      print("Failed to load users: $e");
    }
  }
}
