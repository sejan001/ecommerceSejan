import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_bloc/feature/products/presentation/auth/bloc/login_screen.dart';
import 'package:project_bloc/feature/products/presentation/screen/home_screen.dart';
import 'package:project_bloc/feature/products/presentation/screen/initial_screen.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';

class MyAppRouter extends StatelessWidget {
  MyAppRouter({super.key});

  final GoRouter _goRouter = GoRouter(routes: [
    GoRoute(path: '/', builder: (context, state) => InitialScreen()),
    GoRoute(path: '/homeScreen', builder: (context, state) => HomeScreen()),
    GoRoute(
        path: '/detailsScreen/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return ProductDetailScreen(
            productId: id,
          );
        })
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
