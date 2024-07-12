import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/domain/model/cart_model.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_bloc.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_event.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';

Widget ProductsList() {
  return BlocBuilder<ProductsBloc, ProductsState>(
    builder: (context, state) {
      if (state is ProductsLoading) {
        double width = MediaQuery.sizeOf(context).width * 1;

        double height = MediaQuery.sizeOf(context).height * 1;
        return Center(
            child: Container(
          height: height * .1,
          child: LottieBuilder.network(
              "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
        ));
      } else if (state is ProductsLoaded) {
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final userString =
                        SharedPreferenecesService.getString(key: "currentUser");
                    final userMap =
                        jsonDecode(userString!) as Map<String, dynamic>;
                    final currentUser = User.fromJson(userMap);
                    final product = state.products[index];
                    return GestureDetector(
                      onTap: () {
                        print(product.id);
                        // context.go('/detailsScreen/${product.id}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(id: product.id)));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  tooltip: "Add to cart",
                                  onPressed: () {
                                    BlocProvider.of<CartsBloc>(context).add(
                                        AddProduct(
                                            id: product.id,
                                            title: product.title,
                                            price: product.price,
                                            quantity:
                                                product.minimumOrderQuantity,
                                            discountPercentage:
                                                product.discountPercentage,
                                            thumbnail: product.thumbnail,
                                            userId: currentUser.id));
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("added to cart"),backgroundColor: Colors.green,));

                                    // final Cart cart = Cart(products: Product())
                                  },
                                  icon: Icon(Icons.favorite_border)),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            product.thumbnail.toString()))),
                              ),
                            ),
                            Text(
                              product.title.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "\$ ${product.price.toString()}",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      } else if (state is ProductsError) {
        return Center(child: Text('Error: ${state.error}'));
      } else {
        return const Center(child: Text('Unknown state'));
      }
    },
  );
}
