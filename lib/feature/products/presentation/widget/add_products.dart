import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:project_bloc/feature/products/presentation/cubit/search_products_cubit.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return BlocProvider(
      create: (context) => ProductsBloc(FilterProductsCubit()),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: height * .3,
                      width: width * .5,
                      color: Colors.black38,
                      child: Center(
                        child:
                            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: width * .5,
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                              hintText: "title",
                              labelText: "Enter title",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60))),
                        )),
                    SizedBox(
                      height: height * .03,
                    ),
                    Container(
                        width: width * .5,
                        child: TextFormField( 
                          controller: _priceController,
                          decoration: InputDecoration(
                              hintText: "price",
                              labelText: "Enter price ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60))),
                        )),
                    SizedBox(
                      height: height * .03,
                    ),
                    Container(
                        width: width * .5,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              hintText: "descripton",
                              labelText: "Enter description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60))),
                        )),
                    SizedBox(
                      height: height * .03,
                    ),
                    Container(
                        width: width * .5,
                        child: TextField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                              hintText: "category",
                              labelText: "Enter category",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60))),
                        )),
                    SizedBox(
                      height: height * .03,
                    ),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<ProductsBloc>(context).add(AddProduct(
                              title: _titleController.text,
                              price: _priceController.text,
                              description: _descriptionController.text,
                              category: _categoryController.text));
                        },
                        child: Text("Add"))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
