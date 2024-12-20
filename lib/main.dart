import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/product_blocs/Bloc/products_bloc.dart';
import 'package:project_bloc/auth/bloc/auth_bloc.dart';
import 'package:project_bloc/feature/carts/presentation/cart_bloc/carts_bloc.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filterusers_cubit.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/users_bloc.dart';
import 'package:project_bloc/helpers/internet_cubit.dart';  // Import your InternetCubit
import 'package:project_bloc/helpers/no_internet_screen.dart'; // Import the NoInternetScreen
import 'package:project_bloc/helpers/rebuild_cubit.dart';
import 'core/route/my_app_router.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenecesService.init();
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
        BlocProvider(create: (context) => InternetCubit()), 
        BlocProvider(create: (context) => UsersBloc()),
        BlocProvider(create: (context) => FilterusersCubit()),
           BlocProvider(create: (context) => RebuildCubit()),
      ],
      child: ScreenUtilInit(
        child: BlocListener<InternetCubit, InternetState>(
          listener: (context, state) {
            if (state is InternetDisconnected) {
             
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NoInternetScreen()),
              );
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: MyAppRouter(), 
          ),
        ),
      ),
    );
  }
}
