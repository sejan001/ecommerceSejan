import 'package:project_bloc/feature/products/domain/model/cart_model.dart'
    as C;
import 'package:project_bloc/feature/products/domain/model/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Products> products;

  ProductsLoaded({required this.products});
}

class ProductsError extends ProductsState {
  final String error;

  ProductsError(this.error);
}
