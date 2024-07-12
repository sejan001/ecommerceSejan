import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/presentation/posts/bloc/posts_bloc.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostsBloc>(context).add(fetchAllPosts());
  }

  @override
  Widget build(BuildContext context) {
          double width = MediaQuery.sizeOf(context).width * 1;

        double height = MediaQuery.sizeOf(context).height * 1;
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading ) {
     
        return Center(
            child: Container(
          height: height * .1,
          child: LottieBuilder.network(
              "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
        ));
          
        }
        else if(state is PostsError){
          return Center(child: Text(state.error),);
        }
        else if(state is PostsLoaded){
          return Scaffold(
          body: SafeArea(child: ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context,index){
          
              final post = state.posts[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shadowColor: Colors.orangeAccent,
              child: Column(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text("@user${post.userId}",style: TextStyle(fontWeight: FontWeight.w100,color: Colors.blueAccent),)),
                Align(
                alignment: Alignment.topLeft,
                child: Text("${post.title}",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.orange),)),
               Wrap(
                            children: post.tags!.map<Widget>((tag) {
                              return Text("#${tag}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w100),);
                            }).toList(),
                          ),

                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text("${post.body}",style: TextStyle(fontWeight: FontWeight.w200),textAlign: TextAlign.center,)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [Icon(
                      
                      Icons.thumb_up_sharp,color: Colors.blue,),           Text("${post.reactions!.likes.toString()}",style: TextStyle(fontWeight: FontWeight.w200)),
                    SizedBox(width: width*.02 , ),Icon(Icons.thumb_down_sharp),           Text("${post.reactions!.dislikes.toString()}",style: TextStyle(fontWeight: FontWeight.w200)),
                    SizedBox(width: width*.41,),
                    Icon(Icons.remove_red_eye),           Text("${post.views}",style: TextStyle(fontWeight: FontWeight.w200))],
                  ),
                )
            
            ],),),
          );
          
          
          })),
        );
        }
        return SizedBox.shrink();
      },
    );
  }
}
