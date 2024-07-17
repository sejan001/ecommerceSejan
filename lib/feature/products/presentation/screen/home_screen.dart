import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';


import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/domain/model/cart_model.dart';

import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';
import 'package:project_bloc/feature/products/presentation/widget/cartsScreen.dart';


import 'package:project_bloc/feature/products/presentation/widget/products_list.dart';
import 'package:project_bloc/feature/products/presentation/widget/profile%20_screen.dart';

import 'post_screen.dart';

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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  int _selectedIndex = 0;

  static List<Widget> _pages = [];
List<Product> product = [];
  @override
  void initState() {
    super.initState();
    print("user hoooo ${widget.user.firstName}");
    _pages = [
      ProductsList(),
           PostsTab(),
      CartsTab(user: widget.user),
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
        return StatefulBuilder(
          builder: (context, setState) {
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
          }
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
                 
                             context.go("/login");                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("logged out"),backgroundColor: Colors.red,));
                 
                 
                 
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
                Container(
                  height: height * .1,
                  width: width * .40,
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

                SizedBox(
                  width: width*.12,
                  child: LottieBuilder.network("https://lottie.host/95700c24-bfef-4faa-a3ec-a1e47582c2d9/hUkHNSyQXU.json"),
                )


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
            icon: Icon(Icons.home,color: Colors.black,),
          ),
           BottomNavigationBarItem(
            label: "Posts",
            icon: Icon(Icons.social_distance_outlined,color: Colors.black,),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.shopping_cart,color: Colors.black,),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person,color: Colors.black,),
          ),
         
        ],
        currentIndex: _selectedIndex,
        onTap: _onTappedItem,
          selectedItemColor: Colors.orange,
        unselectedLabelStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w600),
        selectedLabelStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w600),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
        onPressed: () {
          _addProducts(height, width);
        },
        child: Icon(Icons.add_business_outlined),
      ),
    );
  }

  Widget _addProducts(double height, double width) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Add Products"),
                content: Container(
                  height: height * .53,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                     Container(
                      height: height*.16,
                      width: width*.3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(image: _image != null ? FileImage(File(_image!.path)): NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg"),fit: BoxFit.cover)),),
                            SizedBox(
                              width: width * .015,
                            ),
                            IconButton(
                                onPressed: () {
                                  Future<void> imagePicker() async {
                                    final pickedFile = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        _image = File(pickedFile.path);
                                      });
                                    }
                                  }
                                  
                                  imagePicker();
                                },
                                icon: Icon(Icons.add_a_photo_outlined))
                                  
                          ],
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "Enter product's title"),
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        TextField(
                          controller: _priceController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "Enter product's price"),
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "describe your product"),
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        TextField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder( 
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "Enter product's category"),
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        TextButton(onPressed: (){
                          BlocProvider.of<ProductsBloc>(context).add(AddProduct(title: _titleController.text,price: _priceController.text, description: _descriptionController.text,
                          category: _categoryController.text,thumbnail: _image != null ? _image!.path.toString() : ''));
                        }, child: Text("Add Products",style: TextStyle(color: Colors.orange),))
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        });
    return SizedBox.shrink();
  }
}
