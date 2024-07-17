import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/products/domain/model/post_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<fetchAllPosts>(_getPosts);

}
  
  Future<void> _getPosts(fetchAllPosts event, Emitter<PostsState> emit ) async{
    emit(PostsLoading());
    try {
      final List<Posts>  posts = await RepoProvider().fetchPosts(event.id);
    print("bloc ma posts aayo $posts");
    emit(PostsLoaded(posts: posts));

    } catch (e) {
      emit(PostsError(error: "$e"));
      
    }
  }

}