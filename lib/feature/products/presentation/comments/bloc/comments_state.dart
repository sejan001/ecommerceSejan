part of 'comments_bloc.dart';

sealed class CommentsState extends Equatable {
  const CommentsState();
  
  @override
  List<Object> get props => [];
}

final class CommentsInitial extends CommentsState {}
final class   CommentsLoading extends CommentsState {}
final class CommentsLoaded extends CommentsState {
  final CommentsModel comments;

CommentsLoaded({required this.comments});
}
final class CommentsError extends CommentsState {
  final String message;
  CommentsError({required this.message});
}