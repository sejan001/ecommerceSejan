import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_events.dart';

import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/products/presentation/widget/cartsScreen.dart';

import 'package:project_bloc/feature/products/presentation/widget/products_list.dart';
import 'package:project_bloc/feature/products/presentation/widget/profile%20_screen.dart';

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
  int _selectedIndex = 0;

  static List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    print("user hoooo ${widget.user.firstName}");
    _pages = [
      ProductsList(),
      CartsTab(user: widget.user),
      ProfileTab(
        user: widget.user,
      )
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
        return AlertDialog(
          title: Text("Limit and skip"),
          content: Container(
            height: 200,
            width: double.maxFinite,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Limit"),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _limitController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
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
                    Text("Skip"),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _skipController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter skip',
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
                context.read<FilterProductsCubit>().updateSkip(skip.toString());
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
              child: Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Drawer(
        width: width * .3,
        child: ListView(
          children: <Widget>[
            Container(
              height: height * .1,
              child: DrawerHeader(child: Center(child: Text("Menu"))),
            ),
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
                Container(
                  height: height * .1,
                  width: width * .5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTappedItem,
      ),
    );
  }
}
