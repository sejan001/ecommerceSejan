import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/products/domain/model/comments_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<fetchComments>(fetchComment);

 
  }
     Future<void> fetchComment (fetchComments event , Emitter<CommentsState> emit) async{
  emit(CommentsLoading());
 try {
CommentsModel model = await RepoProvider().fetchComments(event.postID);
    print("comments aayo $model");
    emit(CommentsLoaded(comments: model));
 } catch (e) {
   emit(CommentsError(message: '$e'));
 }
}

}

