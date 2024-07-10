class Product {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      total: json['total'],
      discountPercentage: json['discountPercentage'],
      discountedTotal: json['discountedTotal'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'total': total,
      'discountPercentage': discountPercentage,
      'discountedTotal': discountedTotal,
      'thumbnail': thumbnail,
    };
  }
}

class Cart {
  final int id;
  final List<Product> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  Cart({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;
    List<Product> productList =
        productsList.map((product) => Product.fromJson(product)).toList();

    return Cart(
      id: json['id'],
      products: productList,
      total: json['total'],
      discountedTotal: json['discountedTotal'],
      userId: json['userId'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
      'discountedTotal': discountedTotal,
      'userId': userId,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
    };
  }
}

class UserCartResponse {
  final List<Cart> carts;
  final int total;
  final int skip;
  final int limit;

  UserCartResponse({
    required this.carts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UserCartResponse.fromJson(Map<String, dynamic> json) {
    var cartsList = json['carts'] as List;
    List<Cart> cartList = cartsList.map((cart) => Cart.fromJson(cart)).toList();

    return UserCartResponse(
      carts: cartList,
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carts': carts.map((cart) => cart.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}
