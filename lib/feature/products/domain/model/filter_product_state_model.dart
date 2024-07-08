class FilterProductStateModel {
  final String? limit;
  final String? skip;
  final String? category;

  final String? searchQuery;
  final String? id;

  FilterProductStateModel({
    this.limit,
    this.skip,
    this.category,
    this.searchQuery,
    this.id,
  });

  FilterProductStateModel copyWith(
      {String? limit,
      String? skip,
      String? searchQuery,
      String? id,
      String? category}) {
    return FilterProductStateModel(
        limit: limit ?? this.limit,
        searchQuery: searchQuery ?? this.searchQuery,
        skip: skip ?? this.skip,
        category: category ?? this.category,
        id: id ?? this.id);
  }
}
