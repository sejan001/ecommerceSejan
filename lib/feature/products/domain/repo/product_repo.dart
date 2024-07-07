import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';

class ProductsRepository {
  String api = "https://dummyjson.com/products";

  Future<List<Products>> fetchProducts(
      {required FilterProductStateModel model}) async {
    if (model.searchQuery != null) {
      api = '$api/search?q=${model.searchQuery}';
      print("api hooo $api");
    }
    var uri = Uri.parse(api);

    final queryParams = {
      if (model.limit != null) 'limit': model.limit.toString(),
      if (model.id != null) 'id': model.id.toString(),
      if (model.skip != null) 'skip': model.skip.toString(),
      if (model.category != null) 'category': model.category,
      if (model.searchQuery != null) 'q': model.searchQuery,
    };

    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json.containsKey('products')) {
        final List<dynamic> productsJson = json['products'];
        return productsJson
            .map((productJson) => Products.fromJson(productJson))
            .toList();
      } else {
        throw Exception('Products not found in response');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Products>> addProduct(String title, String? description,
      String? thumbnail, String? category) async {
    String url = "https://dummyjson.com/products/add";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'title': title,
        'thumbnail': thumbnail,
        'description': description,
        "category": category
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("success added");
      print(response.body);
    } else {
      print("success vaenaa");
      print(response.statusCode);
    }
    return [];
  }

  Future<void> deleteProduct(String id) async {
    String apiUrl = "$api/$id";

    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Product deleted successfully");
      print(response.body);
    } else {
      print("Failed to delete product. Status code: ${response.statusCode}");
      throw Exception('Failed to delete product');
    }
  }

  Future<User> getToken(var username, var password) async {
    const String api = 'https://dummyjson.com/auth/login';
    try {
      final response = await http.post(Uri.parse(api),
          body: jsonEncode({'username': username, 'password': password}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        User user = User(
            username: username,
            email: data['email'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            gender: data['gender'],
            token: data['token'],
            id: data['id']);
        print(user);
        print("token aayo");
        print(response.body);
        return user;
      } else {
        print(response.statusCode);
        print("token aaena");
      }
    } catch (e) {
      throw Exception();
    }
    throw 0;
  }
}
