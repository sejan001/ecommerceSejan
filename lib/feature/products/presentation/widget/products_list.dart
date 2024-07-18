import 'dart:async';
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/bloc/carts_event.dart';
import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';

import '../bloc/carts_bloc.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  PageController _pageController = PageController();
 List<int?> addedCarts =[];
  int? cartProduct;
  int _currentPage = 0;
  List<String> images = [
    'https://img.freepik.com/free-psd/banner-shopping-sale-template_23-2148797677.jpg',
    "https://img.freepik.com/free-vector/abstract-colorful-sales-banner_52683-27977.jpg?size=626&ext=jpg&ga=GA1.1.87170709.1707696000&semt=ais",
    "https://img.freepik.com/premium-vector/online-shopping-banner_268722-565.jpg"
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
  }

  @override
  Widget build(BuildContext context) {
 
    double height = MediaQuery.sizeOf(context).height * 1;
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
                          SharedPreferenecesService.getString(key: "currentUser");
                      final userMap =
                          jsonDecode(userString!) as Map<String, dynamic>;
                      final currentUser = User.fromJson(userMap);
                      final product = state.products[index];
                         bool showCartGif = addedCarts.contains(product.id);
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
                                    setState(() {
                                     addedCarts.add(product.id);
                                      
                                    });
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("added ${product.title} to cart"),
                                            backgroundColor: Colors.green,));
                                  },
                                  icon:  showCartGif? SizedBox(height: 60,
                                    child:  LottieBuilder.network("https://lottie.host/01a8a168-ad27-4b34-bbe6-3914326d5635/Q1lHGGbZmv.json")): Icon(Icons.favorite_border) 
                                ),
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
                    },
                  );
                } else if (state is ProductsError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
