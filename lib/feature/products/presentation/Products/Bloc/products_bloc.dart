import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';
import 'package:project_bloc/feature/products/presentation/Products/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/presentation/Products/Bloc/products_state.dart';


import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';

class ProductsBloc extends Bloc<ProductsEvents, ProductsState> {
  final FilterProductsCubit searchProductsCubit;
  ProductsBloc(this.searchProductsCubit) : super(ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);

    on<AddProduct>(_addProduct);
    // on<DeleteProduct>(_deleteProduct);
  }
}

Future<void> _onFetchProducts(
    FetchProducts event, Emitter<ProductsState> emit) async {
  emit(ProductsLoading());
  try {
    print("Fetched products with name: ${event.filterModel.id} ");

    final List<Products> products = await RepoProvider().fetchProducts(model:  event.filterModel
    
    );
  
    emit(ProductsLoaded(products: products));
  } catch (e) {
    emit(ProductsError("Failed to fetch products: $e"));
  }
}


Future<void> _addProduct(AddProduct event, Emitter<ProductsState> emit) async {
  try {
    final product = await RepoProvider().addProduct(
        event.title.toString(),
        event.category,
        event.description,
        event.thumbnail);
  } catch (e) {}
}

// Future<void> _deleteProduct(
//     DeleteProduct event, Emitter<ProductsState> emit) async {
//   try {
//     final product = await ProductsRepository().deleteProduct(event.id);
//   } catch (e) {
//     print("oo $e");
//   }
// }
