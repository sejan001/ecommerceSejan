import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/auth/bloc/auth_bloc.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_bloc.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/products/presentation/posts/bloc/posts_bloc.dart';

import 'core/route/my_app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferenecesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc(FilterProductsCubit())),
        BlocProvider(create: (context) => FilterProductsCubit()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => CartsBloc()),
              BlocProvider(create: (context) => PostsBloc()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyAppRouter(),
      ),
    );
  }
}
