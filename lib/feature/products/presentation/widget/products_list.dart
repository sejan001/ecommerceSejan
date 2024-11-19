import 'dart:async';
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/carts/model/cart_model.dart';
import 'package:project_bloc/auth/model/user_model.dart';
import 'package:project_bloc/feature/carts/presentation/cart_bloc/carts_bloc.dart';
import 'package:project_bloc/feature/carts/presentation/cart_bloc/carts_event.dart';
import 'package:project_bloc/feature/carts/widgets/cartsScreen.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/product_blocs/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/product_blocs/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../../helpers/rebuild_cubit.dart';

class ProductsList extends StatefulWidget {

  User user;
   ProductsList({super.key, required this.user});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  PageController _pageController = PageController();
  List<Cart> carts = [];
  List<int?> addedCarts = [];
  List<Cart> savedCart = [];
  Uuid uuid = Uuid();
  int? cartProduct;
  int _currentPage = 0;
  List<String> images = [
    'https://img.freepik.com/premium-vector/vector-gradient-blue-colored-sale-banner-sale-banner-discount-promotion-blue-background-concept_497837-1635.jpg',
    "https://t4.ftcdn.net/jpg/06/95/44/49/360_F_695444999_u7jr5p6NJKsZAOGGwZqzevKRF8o9UDkT.jpg",
    "https://as2.ftcdn.net/v2/jpg/02/10/60/47/1000_F_210604798_L1oeENismr3DpyhYGd9mMT8WhNcuqoi1.jpg"
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 0;
        });
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    String? json = SharedPreferenecesService.getString(key: 'userCarts');
    if (json != null && json.isNotEmpty) {
      UserCartResponse d = UserCartResponse.fromJson(jsonDecode(json));
      savedCart = d.carts;
    } else {
      savedCart = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    return BlocBuilder<RebuildCubit, RebuildState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: height * 0.3,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(20.0),
                  child: DotsIndicator(
                    decorator: DotsDecorator(activeColor: Colors.orange),
                    dotsCount: images.length,
                    position: _currentPage,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return Center(
                        child: Container(
                          height: height * 0.1,
                          child: LottieBuilder.network(
                              "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
                        ),
                      );
                    } else if (state is ProductsLoaded) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          crossAxisCount: 2,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final userString =
                              SharedPreferenecesService.getString(
                                  key: "currentUser");
                          final userMap =
                              jsonDecode(userString!) as Map<String, dynamic>;
                          final currentUser = User.fromJson(userMap);

                          Cart userCart = savedCart.firstWhere(
                              (cart) => cart.userId == currentUser.id,
                              orElse: () => Cart(
                                  userId: currentUser.id!,
                                  products: [],
                                  total: 0,
                                  discountedTotal: 0,
                                  id: currentUser.id!,
                                  totalProducts: 0,
                                  totalQuantity: 0));

                          final product = state.products[index];
                          final cartProduct = Product(
                            id: product.id!.toInt(),
                            title: product.title.toString(),
                            price: product.price!.toDouble(),
                            quantity: 1,
                            total: product.price!.toDouble(),
                            discountPercentage:
                                product.discountPercentage!.toDouble(),
                            discountedTotal: product.price!.toDouble() -
                                (product.price!.toDouble() *
                                    (product.discountPercentage!.toDouble() /
                                        100)),
                            thumbnail: product.thumbnail.toString(),
                          );

                          String? json = SharedPreferenecesService.getString(
                              key: "userCarts");
                          UserCartResponse userCarts;
                          if (json != null && json.isNotEmpty) {
                            userCarts =
                                UserCartResponse.fromJson(jsonDecode(json));
                          } else {
                            userCarts = UserCartResponse(
                                carts: [], total: 0, limit: 0, skip: 0);
                          }
if (true) {
  
}
                          bool showCartGif = userCart.products
                              .any((product) => product.id == cartProduct.id);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(id: product.id)));
                            },
                            child: Card(
                              borderOnForeground: true,
                              elevation: 10,
                              shadowColor: Colors.orange,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      tooltip: "Add to cart",
                                      onPressed: () {
                                        if (showCartGif) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  " ${product.title} is already in cart"),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 168, 175, 76),
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            double total = 0;
                                            double discountedTotal = 0;
                                            int totalProducts = 0;
                                            int totalQuantity = 0;

                                            if (userCarts.carts.isNotEmpty) {
                                              Cart? existingCart;

                                              for (var cart
                                                  in userCarts.carts) {
                                                if (cart.userId ==
                                                    currentUser.id) {
                                                  existingCart = cart;
                                                  break;
                                                }
                                              }

                                              if (existingCart != null) {
                                                total = existingCart.total;
                                                discountedTotal = existingCart
                                                    .discountedTotal;
                                                totalProducts =
                                                    existingCart.totalProducts;
                                                totalQuantity =
                                                    existingCart.totalQuantity;

                                                existingCart.products
                                                    .add(cartProduct);
                                                total += cartProduct.price;
                                                discountedTotal +=
                                                    cartProduct.discountedTotal;
                                                totalProducts = existingCart
                                                    .products.length;
                                                totalQuantity += 1;
                                              } else {
                                                existingCart = Cart(
                                                  id: currentUser.id!,
                                                  products: [cartProduct],
                                                  total: cartProduct.price,
                                                  discountedTotal: cartProduct
                                                      .discountedTotal,
                                                  userId: currentUser.id!,
                                                  totalProducts: 1,
                                                  totalQuantity: 1,
                                                );
                                                userCarts.carts
                                                    .add(existingCart);
                                              }
                                            } else {
                                              // Create the first cart
                                              Cart newCart = Cart(
                                                id: currentUser.id!,
                                                products: [cartProduct],
                                                total: cartProduct.price,
                                                discountedTotal:
                                                    cartProduct.discountedTotal,
                                                userId: currentUser.id!,
                                                totalProducts: 1,
                                                totalQuantity: 1,
                                              );
                                              userCarts.carts.add(newCart);
                                            }

                                            final updatedCartJson =
                                                userCarts.toJson();
                                            context.read<CartsBloc>().add(
                                                AddProduct(
                                                    id: currentUser.id,
                                                    title: product.title,
                                                    price: product.price,
                                                    quantity:
                                                        cartProduct.quantity,
                                                    discountPercentage:
                                                        cartProduct
                                                            .discountPercentage,
                                                    thumbnail:
                                                        product.thumbnail,
                                                    userId: currentUser.id));
                                                    
                                            SharedPreferenecesService.setString(
                                                key: "userCarts",
                                                value: jsonEncode(
                                                    updatedCartJson));
                                                     Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartsTab(user: widget.user)));

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Added ${product.title} to cart"),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          });
                                           context.read<RebuildCubit>().triggerRebuild();
                                        }
                                      },
                                      icon: showCartGif
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              product.thumbnail.toString()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    product.title.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "\$ ${product.price.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ProductsError) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else {
                      return const Center(child: Text('Server Error'));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
