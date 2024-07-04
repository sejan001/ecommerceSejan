part of 'product_details_bloc.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();
  
  @override
  List<Object> get props => [];
}

final class ProductDetailsInitial extends ProductDetailsState {}
final class ProductDetailsLoading extends ProductDetailsState {}
final class ProductDetailsLoadedState extends ProductDetailsState {
  final List<Products> product;
  ProductDetailsLoadedState({required this.product});
}

final class ProductDetailsError extends ProductDetailsState {
  final String error;
  ProductDetailsError({required this.error});
}