import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';

class ProductsRepository {
 String api = "https://dummyjson.com/products";

  Future<List<Products>> fetchProducts({required FilterProductStateModel model}) async {
    if(model.searchQuery!= null) { 
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
        return productsJson.map((productJson) => Products.fromJson(productJson)).toList();
      } else {
        throw Exception('Products not found in response');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
