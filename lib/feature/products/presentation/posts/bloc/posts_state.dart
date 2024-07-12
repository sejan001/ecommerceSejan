part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();
  
  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {}
class PostsLoading extends PostsState{}
class PostsLoaded extends PostsState{
final  List<Posts> posts;
PostsLoaded({required this.posts});


}
class PostsError extends PostsState{
  String error;
  PostsError({required this.error});
}

