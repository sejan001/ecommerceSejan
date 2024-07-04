import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/products/presentation/product_details_bloc/product_details_bloc.dart';
import 'package:project_bloc/feature/products/presentation/screen/home_screen.dart';
import 'package:project_bloc/core/route/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductDetailsBloc()),
        BlocProvider(create: (context) => ProductsBloc(FilterProductsCubit())),
          BlocProvider(create: (context)=> FilterProductsCubit()),
      ],
      child: MaterialApp(
        onGenerateRoute: onRouteGenerate,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
