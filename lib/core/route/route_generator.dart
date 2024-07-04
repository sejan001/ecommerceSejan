import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc/core/route/route_names.dart';
import 'package:project_bloc/feature/products/presentation/product_details_bloc/product_details_bloc.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';

Route<dynamic> onRouteGenerate(RouteSettings settings) {
  var name = settings.name;
  var arg = settings.arguments;

  switch (name) {
     case RouteNames.productDetailScreen:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductDetailsBloc()),
            
          ],
          child: ProductDetailScreen(productId: arg),
        ),
      );
      
    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR: Route not found'),
      ),
    );
  });
}
