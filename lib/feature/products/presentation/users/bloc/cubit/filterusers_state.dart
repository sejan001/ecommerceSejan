

import 'package:equatable/equatable.dart';

sealed class FilterusersState extends Equatable {
  const FilterusersState();

  @override
  List<Object> get props => [];
}

final class FilterusersInitial extends FilterusersState {}
class FilterUsers extends FilterusersState{
    final String? limit;
  final String? skip;
  
  final String? searchQuery;
  final String? id;

  FilterUsers({
    this.limit,
    this.skip,

    this.searchQuery,
    this.id,
  });

  FilterUsers copyWith(
      {String? limit,
      String? skip,
      String? searchQuery,
      String? id,
      }) {
    return FilterUsers(
        limit: limit ?? this.limit,
        searchQuery: searchQuery ?? this.searchQuery,
        skip: skip ?? this.skip,
  
        id: id ?? this.id);
  }
  
}