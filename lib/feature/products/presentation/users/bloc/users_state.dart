part of 'users_bloc.dart';

sealed class UsersState extends Equatable {
  const UsersState();
  
  @override
  List<Object> get props => [];
}

final class UsersInitial extends UsersState {}
class UsersLoadingState extends UsersState{
  
}
class UsersLoadedState extends UsersState{
  UserModel users ;
  UsersLoadedState({required this.users});
}

class UserLoadingError extends UsersState{
  String message;
  UserLoadingError({required this.message});
}