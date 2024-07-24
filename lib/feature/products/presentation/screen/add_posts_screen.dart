import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_bloc/feature/products/presentation/Products/Bloc/products_bloc.dart';

import '../Products/Bloc/products_events.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
    TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
    File? _image;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    bool allFilled = _titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _categoryController.text.isNotEmpty &&  _priceController.text.isNotEmpty ;
      double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 186, 186),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Add products",style: TextStyle(
          color: Colors.white,
            fontSize: 19,fontWeight: FontWeight.w300
          )),flexibleSpace: 
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: TextButton(
            style: ButtonStyle(
              
              backgroundColor: MaterialStateProperty.all(allFilled? Colors.orange : const Color.fromARGB(255, 233, 228, 228))
            ),
              onPressed: (){
                if (allFilled) {
                   BlocProvider.of<ProductsBloc>(context).add(AddProduct(title: _titleController.text,price: _priceController.text, description: _descriptionController.text,
                            category: _categoryController.text,thumbnail: _image != null ? _image!.path.toString() : ''));
                            context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Product added successfully",style: 
                  TextStyle(color: Colors.white),)));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Please fill all details",style: 
                  TextStyle(color: Colors.white),)));
                }
              }, child: Text("Add",style: TextStyle(color: allFilled? Colors.white : Colors.black,
            
              fontSize: 18
            ),)),
          ),
        )),),
        body: SingleChildScrollView(
                    child: Column(
                      children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              onChanged: (value){
                                setState(() {
                                  
                                });
                              },
                            controller: _titleController,
                            decoration: InputDecoration(
                              
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.orange),
                                hintText: "Enter product's title"),
                                                    ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                           height: height*.3,
                           width: width*.9,
                           decoration: BoxDecoration(
                             color: Colors.black,
                             image: DecorationImage(image: _image != null ? FileImage(File(_image!.path)): NetworkImage("https://i.pinimg.com/736x/95/66/35/95663504d297d14f15f9d32113f65a89.jpg"),fit: BoxFit.cover)),),
                        ),
                               SizedBox(
                                 width: width * .015,
                               ),
                        SizedBox(
                          height: height * .015,
                        ),
                      GestureDetector(
                        onTap: (){
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
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 198, 191, 191)
                            ),
                            child: ListTile(
                            
                              leading: Icon(Icons.browse_gallery,color: Colors.orange,),
                              title: Text("Select Photo",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                      
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextField(
                              style: TextStyle(color: Colors.white),
                             onChanged: (value){
                                setState(() {
                                  
                                });},
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            
                            decoration: InputDecoration(
                                   hintStyle: TextStyle(color: Colors.orange),
                                
                                hintText: "Enter product's price"),
                          ),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextField(
                              style: TextStyle(color: Colors.white),
                             onChanged: (value){
                                setState(() {
                                  
                                });},
                            controller: _descriptionController,
                            decoration: InputDecoration(
                                   hintStyle: TextStyle(color: Colors.orange),
                                
                                hintText: "describe your product"),
                          ),
                        ),
                      
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextField(
                              style: TextStyle(color: Colors.white),
                             onChanged: (value){
                                setState(() {
                                  
                                });},
                            controller: _categoryController,
                            decoration: InputDecoration(
                                   hintStyle: TextStyle(color: Colors.orange),
                                hintText: "Enter product's category"),
                          ),
                        ),
                      
                      ],
                    ),
                  )
    );
  }
}