import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filter_users_state.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filterusers_cubit.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/users_bloc.dart';

class ProfileTab extends StatefulWidget {
  final User user;
  const ProfileTab({super.key, required this.user});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  TextEditingController _userController = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("user profile aayo ${widget.user.firstName}");
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<UsersBloc>(context).add(FetchUsers(model: FilterUser()));
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
                  SizedBox(
                    height: height * .01,
                  ),
           ]))));
  }
}
