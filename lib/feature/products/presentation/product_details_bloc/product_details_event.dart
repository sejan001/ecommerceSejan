part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailsFetchEvent extends ProductDetailsEvent{
final int id;
final int skip;
final int limit;
final String name;
final String category;


ProductDetailsFetchEvent({required this.limit, required this.id,required this.name, required this.category, required this.skip,});
}