import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_bloc/feature/products/domain/model/cart_model.dart'
    as C;
import 'package:project_bloc/feature/products/domain/model/comments_model.dart' as CM;
import 'package:project_bloc/feature/products/domain/model/complex_user_model.dart';

import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/post_model.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filter_users_state.dart';

class ProductsRepository {
  String api = "https://dummyjson.com/products";
  String cartAPI = 'https://dummyjson.com/carts';

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

  Future<User> getUser(var username, var password) async {
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

  Future<List<C.UserCartResponse>> fetchCarts(int? userId) async {
    try {
      final cartUri = Uri.parse('$cartAPI/user/${userId}');
      final response = await http.get(cartUri);
      print("final responseee $cartUri");
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('carts')) {
          final List<dynamic> carts = data['carts'];
          print("response aaayo ${response.body}");
          return carts
              .map((cart) => C.UserCartResponse.fromJson(cart))
              .toList();
        } else {
          throw Exception('Carts key not found in response');
        }
      } else {
        throw Exception(
            'Failed to fetch carts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching carts: $e');
    }
  }

  Future<List<C.UserCartResponse>> addCart({
    required int? id,
    required String? title,
    required double? price,
    required double? total,
    required int? userId,
    required double? discountPercentage,
    required String? thumbnail,
  }) async {
    try {
      final response = await http.post(Uri.parse("${cartAPI}/add"),
          body: jsonEncode({
            'userId': userId,
            'products': [
              {
                'id': id,
                "title": title,
                "price": price,
                "total": total,
                "discountPercentage": discountPercentage,
                "thumbnail": thumbnail
              }
            ]
          }),
          headers: {"Content-Type": 'application/json'});
      if (response.statusCode == 201 || response.statusCode == 200) {
        SharedPreferenecesService.setString(
            key: "carts", value: jsonEncode(response.body));
        print(response.body);
        print("cart addd vayooo");
      } else {
        print(response.statusCode);
        print("cart addd vaenaaa");
      }
    } catch (e) {
      print("cart ko exception $e");
    }
    throw Exception();
  }
  Future<List<Posts>> fetchPosts(String? id) async{ 
        String postsApi = "https://dummyjson.com/posts";
    if (id != null) {
      postsApi = "https://dummyjson.com/posts/user/$id";

      
    }

    final response = await http.get(Uri.parse(postsApi));
    if (response.statusCode == 200) {
    Map<String,dynamic> json = jsonDecode(response.body);
    if (json.containsKey("posts")) {
    final List<dynamic> posts = json['posts'];
    print("posts aayooo $posts");
    return posts.map((post)=> Posts.fromJson(post)).toList();


      
    }
    else{
      throw Exception();
    }
      
    }
    else{
      return [];
    }
    

  }
Future<UserModel> fetchUsers({required FilterUser model}) async {
  String urlUsers = 'https://dummyjson.com/users';


  if (model.name != null) {
    urlUsers = '$urlUsers/search?q=${model.name}';
  }

  var url = Uri.parse(urlUsers);

  final queryParams = {
    if (model.limit != null) 'limit': model.limit.toString(),
    if (model.id != null) 'id': model.id.toString(),
    if (model.skip != null) 'skip': model.skip.toString(),
    if (model.name != null) 'q': model.name,
  };

  if (queryParams.isNotEmpty) {
    url = url.replace(queryParameters: queryParams);
  }

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch users');
    }
  } catch (e) {
    print('Error fetching users: $e');
    throw Exception('Error fetching users: $e');
  }
}
Future<CM.CommentsModel> fetchComments (String postID) async {
  String commentsApi = "https://dummyjson.com/comments";
  if (postID.isNotEmpty) {
    commentsApi = '${commentsApi}/post/$postID';
    
  }
  try {
    final response = await http.get(Uri.parse(commentsApi));
    if (response.statusCode == 200) {
      return CM.CommentsModel.fromJson(jsonDecode(response.body));
      
    }

    
  } catch (e) {
    
print("comments ko errror $e");
  }
  throw Exception();
}
}
