import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:project_bloc/feature/carts/model/cart_model.dart';

import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/auth/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/product_blocs/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/product_blocs/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/carts/widgets/cartsScreen.dart';

import 'package:project_bloc/feature/products/presentation/widget/products_list.dart';
import 'package:project_bloc/feature/user/presentation/screens/profile%20_screen.dart';
import 'package:project_bloc/helpers/rebuild_cubit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _limitController = TextEditingController();
  TextEditingController _skipController = TextEditingController();

  String cartNo = '0';
  int _selectedIndex = 0;

  static List<Widget> _pages = [];

  List<Product> product = [];

  @override
  void initState() {
    super.initState();
    print("user hoooo ${widget.user.firstName}");
    _pages = [
      ProductsList(user: widget.user,),
      ProfileTab(
        user: widget.user,
      ),
    ];
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      BlocProvider.of<ProductsBloc>(context)
          .add(FetchProducts(filterModel: FilterProductStateModel()));
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _limitController.dispose();
    _skipController.dispose();
    super.dispose();
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filter() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.orangeAccent,
            title: Text(
              "Limit and skip",
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              height: 140,
              width: double.maxFinite,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Limit",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _limitController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter limit',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Skip", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _skipController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter skip',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final int limit = int.tryParse(_limitController.text) ?? 10;
                  final int skip = int.tryParse(_skipController.text) ?? 0;
                  context.read<FilterProductsCubit>().updateLimit(limit);
                  context
                      .read<FilterProductsCubit>()
                      .updateSkip(skip.toString());
                  FilterProductStateModel filterState =
                      context.read<FilterProductsCubit>().state;
                  if (_limitController.text == null ||
                      _limitController.text.isEmpty) {
                    _limitController.text = 0.toString();
                  }
                  if (_skipController.text == null ||
                      _skipController.text.isEmpty) {
                    _skipController.text = 0.toString();
                  }

                  BlocProvider.of<ProductsBloc>(context).add(FetchProducts(
                    filterModel: filterState.copyWith(
                      searchQuery: _productNameController.text,
                      limit: _limitController.text,
                      skip: _skipController.text,
                    ),
                  ));
                  Navigator.of(context).pop();
                },
                child: Text("Apply", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? json = SharedPreferenecesService.getString(key: 'userCarts');
    if (json != null && json.isNotEmpty) {
      UserCartResponse d = UserCartResponse.fromJson(jsonDecode(json));
      setState(() {
        cartNo = d.carts[0].products.length.toString();
      });
    } else {}
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<RebuildCubit, RebuildState >(
      builder: (context, state) {
   
        return Scaffold(
          drawer: Drawer(
            width: width * .5,
            child: ListView(
              children: <Widget>[
                Container(
                  height: height * .1,
                  child: DrawerHeader(child: Center(child: Text("Menu"))),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.orange)),
                    onPressed: () {
                      setState(() {
                        SharedPreferenecesService.removeString(key: "token");
                        SharedPreferenecesService.removeString(
                            key: "currentUser");
                        context.go("/login");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("logged out"),
                          backgroundColor: Colors.red,
                        ));
                      });
                    },
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.orangeAccent,
            title: Text("Sejan"),
            centerTitle: true,
            actions: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      height: height * .1,
                      width: width * .60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            FilterProductStateModel filterState =
                                context.read<FilterProductsCubit>().state;

                            BlocProvider.of<ProductsBloc>(context).add(
                              FetchProducts(
                                filterModel: filterState.copyWith(
                                  searchQuery: _productNameController.text,
                                  limit: 0.toString(),
                                  skip: 0.toString(),
                                ),
                              ),
                            );
                          },
                          controller: _productNameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "Enter product's name",
                            labelText: "Search Products",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_productNameController.text.trim().isNotEmpty) {
                          setState(() {
                            FilterProductStateModel filterState =
                                context.read<FilterProductsCubit>().state;

                            BlocProvider.of<ProductsBloc>(context).add(
                              FetchProducts(
                                filterModel: filterState.copyWith(
                                  searchQuery: _productNameController.text,
                                  limit: _limitController.text,
                                  skip: _skipController.text,
                                ),
                              ),
                            );
                          });
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: _filter,
                      icon: Icon(Icons.select_all_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onTappedItem,
            selectedItemColor: Colors.orange,
            unselectedLabelStyle:
                TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
            selectedLabelStyle:
                TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartsTab(user: widget.  user)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart),
                cartNo != "0"
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Center(child: Text(cartNo)))
                    : SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}
