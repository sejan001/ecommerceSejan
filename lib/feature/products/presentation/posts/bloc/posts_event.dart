part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}
class fetchAllPosts extends PostsEvent{ 
  String? id;
   fetchAllPosts({this.id});

}