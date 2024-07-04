part of 'search_products_cubit.dart';

sealed class SearchProductsState extends Equatable {
  const SearchProductsState();

  @override
  List<Object> get props => [];
}
final class SearchProductsInitial extends SearchProductsState {
  
}

final class SearchProductsLoaded extends SearchProductsState {
  final int? id;
  final int? limit;
  final int? skip;
  final String? category;
  final String? name;
  SearchProductsLoaded({required this.id, required this.limit,required this.skip, required this.category,required this.name});
SearchProductsLoaded copyWith({int? id, int? limit, int? skip, String? name,String? category}){
  return SearchProductsLoaded(category: category ?? this.category,
  id: id ?? this.id,
  name: name ?? this.name,
  limit: limit ?? this.limit,
  skip: skip ?? this.skip
  );
}
  

}