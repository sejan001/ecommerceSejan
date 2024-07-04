import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';

import 'package:project_bloc/feature/products/domain/model/product_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<ProductDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
Future<void> fetchDetails(ProductDetailsFetchEvent event, Emitter<ProductDetailsState> emit) async{
  emit(ProductDetailsLoading());
try {
    final List<Products> product = await ProductsRepository().fetchProducts(model: FilterProductStateModel());
  emit(ProductDetailsLoadedState(product: product));
  
} catch (e) {
  emit(ProductDetailsError(error: '$e'));
}
} 
