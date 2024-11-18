import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_bloc/auth/model/user_model.dart';
import 'package:project_bloc/auth/bloc/login_screen.dart';

import 'package:project_bloc/home_screen.dart';
import 'package:project_bloc/initial_screen.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';
import 'package:project_bloc/feature/user/presentation/screens/profile%20_screen.dart';

class MyAppRouter extends StatelessWidget {
  MyAppRouter({super.key});

  final GoRouter _goRouter = GoRouter(
    // initialLocation: "/addPost",
    routes: [
    GoRoute(path: '/', builder: (context, state) => InitialScreen()
        // builder: (context, state) => ProfileTab(
        //       user: User(
        //           id: 1,
        //           username: "username",
        //           email: "email",
        //           firstName: "firstName",
        //           lastName: "lastName",
        //           gender: "gender",
        //           token: "token"),
        //     )),
        ),
    GoRoute(

        path: '/homeScreen/:user',
        builder: (context, state) {
          final String userJson = state.pathParameters['user'] ?? '';
          final User user = User.fromJson(jsonDecode(userJson));
          return HomeScreen(user: user);
        }),
    GoRoute(path: "/login", builder: (context, state) => Login()),
     
    GoRoute(
        path: "/profileTab:user",
        builder: (context, state) {
          final User user = state.pathParameters["user"] as User;
          return ProfileTab(user: user);
        }),
            GoRoute(
        path: '/detailsScreen/:id',
        builder: (context, state) =>
            ProductDetailScreen(id: state.pathParameters["id"]!)),
 
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: _goRouter.routeInformationParser,
      routeInformationProvider: _goRouter.routeInformationProvider,
      routerDelegate: _goRouter.routerDelegate,
    );
  }
}
