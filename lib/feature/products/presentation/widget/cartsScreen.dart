import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_bloc.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_event.dart';

class CartsTab extends StatefulWidget {
  final User user;

  CartsTab({required this.user});

  @override
  _CartsTabState createState() => _CartsTabState();
}

class _CartsTabState extends State<CartsTab> {
  @override
  void initState() {
    super.initState();
    print("id hooo ${widget.user.id}");
    final String? json = SharedPreferenecesService.getString(key: 'carts');
    print("carts jsonnnn $json");

    context.read<CartsBloc>().add(fetchCarts(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartsBloc, CartsState>(
      builder: (context, state) {
        if (state is CartsLoading) {
          // double width = MediaQuery.sizeOf(context).width * 1;
          double height = MediaQuery.sizeOf(context).height * 1;
          return Center(
              child: Container(
            height: height * .1,
            child: LottieBuilder.network(
                "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
          ));
        } else if (state is cartsLoadedState) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                    ),
                    itemCount: state.carts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // print(" cart hoooo 2 ${cart.id}");
                          // // context.go('/detailsScreen/${product.id}');
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             ProductDetailScreen(id: cartId)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              // Expanded(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         image: DecorationImage(
                              //             image: NetworkImage(cart
                              //                 .products![index].thumbnail
                              //                 .toString()))),
                              //   ),
                              // ),
                              // Text(
                              //   cart.products.toString(),
                              //   style: TextStyle(fontWeight: FontWeight.w700),
                              //   textAlign: TextAlign.center,
                              // ),
                              // Text(
                              //   "\$ ${cart.products![index].price.toString()}",
                              //   style: TextStyle(fontWeight: FontWeight.w300),
                              // ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        } else if (state is CartsError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
