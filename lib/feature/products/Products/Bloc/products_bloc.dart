import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';

class ProductsBloc extends Bloc<ProductsEvents, ProductsState> {

  final FilterProductsCubit searchProductsCubit;
  ProductsBloc(this.searchProductsCubit) : super(ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductsState> emit) async {
  emit(ProductsLoading()); 
  try {

    print("Fetched products with name: ${event.filterModel.searchQuery} ");


    final List<Products> products = await ProductsRepository().fetchProducts(
      model: event.filterModel,
    );
    print("filter hoo ${event.filterModel.limit}");
    emit(ProductsLoaded(products: products));
  } catch (e) {
    
    emit(ProductsError("Failed to fetch products: $e"));
  }




  


  

}}





  

