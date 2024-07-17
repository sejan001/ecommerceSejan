import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/presentation/comments/bloc/comments_bloc.dart';
import 'package:project_bloc/feature/products/presentation/posts/bloc/posts_bloc.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  int? selectedPostId;
int? commentsNumber;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostsBloc>(context).add(fetchAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading) {
          return Center(
            child: Container(
              height: height * .1,
              child: LottieBuilder.network(
                  "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
            ),
          );
        } else if (state is PostsError) {
          return Center(
            child: Text(state.error),
          );
        } else if (state is PostsLoaded) {
          return Scaffold(
            body: SafeArea(
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  final isSelected = selectedPostId == post.id;

                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shadowColor: Colors.orangeAccent,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "@user${post.userId}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.blueAccent),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${post.title}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.orange),
                                )),
                            Wrap(
                              children: post.tags!.map<Widget>((tag) {
                                return Text(
                                  "#${tag}",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w100),
                                );
                              }).toList(),
                            ),
                            Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: Text(
                                  "${post.body}",
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                  textAlign: TextAlign.center,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_sharp,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                      "${post.reactions!.likes.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  SizedBox(
                                    width: width * .02,
                                  ),
                                  Icon(Icons.thumb_down_sharp),
                                  Text(
                                      "${post.reactions!.dislikes.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  SizedBox(
                                    width: width * .1,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (selectedPostId == post.id) {
                                                selectedPostId = null;
                                              } else {
                                                selectedPostId = post.id;
                                                BlocProvider.of<CommentsBloc>(
                                                        context)
                                                    .add(fetchComments(
                                                        postID:
                                                            post.id.toString()));
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.comment)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width * .15,
                                  ),
                                  Icon(Icons.remove_red_eye),
                                  Text("${post.views}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200))
                                ],
                              ),
                            ),
                            if (isSelected)
                              BlocBuilder<CommentsBloc, CommentsState>(
                                builder: (context, state) {
                                  if (state is CommentsLoading) {
                                    return Center(
                                      child: Container(
                                        height: height * .07,
                                        child: LottieBuilder.network(
                                            "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
                                      ),
                                    );
                                  } else if (state is CommentsLoaded) {
                                     if (state.comments.comments!.isNotEmpty) {
                                      return Container(
                                        height: height * .3,
                                        child: ListView.builder(
                                          itemCount: state.comments.comments!.length,
                                          itemBuilder: (context, index) {
                                            final comment = state.comments.comments![index];
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                
                                                decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: Text("@${comment.user?.username}",style: TextStyle(color: Colors.blue)),
                                                      subtitle: Text("${comment.body}",style: TextStyle(fontWeight: FontWeight.w700),),
                                                      
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                        Icon(Icons.thumb_up_sharp,color: Colors.orangeAccent),Text(comment.likes.toString())
                                                      ],),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("No comments available"),
                                      );
                                    }
                                  } else if (state is CommentsError) {
                                    return Center(
                                      child: Text(state.message),
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
