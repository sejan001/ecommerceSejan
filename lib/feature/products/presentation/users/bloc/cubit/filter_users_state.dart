class FilterUser {
    final String? limit;
  final String? skip;
  
  final String? name;
  final String? id;

  FilterUser({
    this.limit,
    this.skip,

    this.name,
    this.id,
  });

  FilterUser copyWith(
      {String? limit,
      String? skip,

      String? name,
      String? id,
      }) {
    return FilterUser(
        limit: limit ?? this.limit,
        name: name ?? this.name,
        skip: skip ?? this.skip,
  
        id: id ?? this.id);
  }
  
}