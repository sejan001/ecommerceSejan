part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}
class fetchComments extends CommentsEvent {
  final String postID;
  fetchComments({required this.postID});
}