import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/domain/model/complex_user_model.dart';


import 'package:project_bloc/feature/products/presentation/posts/bloc/posts_bloc.dart';


class UserDetails extends StatefulWidget {
  final Users user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  @override
  void initState() {
    super.initState();
    print("user profile aayo ${widget.user.firstName}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<PostsBloc>(context).add(fetchAllPosts(id: widget.user.id.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // final User mockUser = User(
    //   id: 1,
    //   username: "emilys",
    //   email: "emily.johnson@x.dummyjson.com",
    //   firstName: "Emily",
    //   lastName: "Johnson",
    //   gender: "female",
    //   image: "https://dummyjson.com/icon/emilys/128",
    //   token:
    //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMTc0MCwiZXhwIjoxNzE3NjE1MzQwfQ.eQnhQSnS4o0sXZWARh2HsWrEr6XfDT4ngh0ejiykfH8",
    // );

    String profileImage = widget.user.image.toString();
    if (widget.user.image == null || widget.user.image!.isEmpty) {
      setState(() {
        profileImage =
            "https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg";
      });
    }
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CircleAvatar(
                    radius: 50,
                    child: Image.network(profileImage),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Text(
                    '${widget.user.firstName.toString()} ${widget.user.lastName.toString()} ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.orange),
                  ),
                  Text('sex: ${widget.user.gender.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      )),
                  Text('${widget.user.email.toString()}',
                      style: TextStyle(fontWeight: FontWeight.w200)),
                  Text('${widget.user.phone.toString()}',
                      style: TextStyle(fontWeight: FontWeight.w200)),
                  SizedBox(
                    height: height * .01,
                  ),
                  Text("User' Posts",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.blue)),
                  BlocBuilder<PostsBloc, PostsState>(
                    builder: (context, state) {
                      if (state is PostsLoading) {
      return Center(
            child: Container(
          height: height * .07,
          child: LottieBuilder.network(
              "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
        ));
    }
                   else   if (state is PostsLoaded) {
                        return Expanded(
                          child: Container(
                        child: ListView.builder(
                          itemCount: state.posts.length,
                          itemBuilder: (context, index){
                          final post = state.posts[index];
                         return  Card(
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
                         
                         ],),);
                                  
                        }),
                                              ));
                      }
                    else if(state is PostsError){
                      
                      Center(child: Text("No posts"),);
                    }
                    
                     return Text("No posts");
                 
                    },
                    
                  )
                ]))));
  }
}
