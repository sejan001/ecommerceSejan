import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/core/route/route_names.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';

Widget ProductsList(){
  
  return BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            double width = MediaQuery.sizeOf(context).width*1;

      double height = MediaQuery.sizeOf(context).height*1;
            return   Center(child: Container(
            height: height*.1,
            child: LottieBuilder.network("https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),));
          
          } else if (state is ProductsLoaded) {
            return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5
              ,
              mainAxisSpacing: 5,
              crossAxisCount: 2,),
            itemCount: state.products.length,
           
             itemBuilder: (context,index){
               final product = state.products[index];
              return GestureDetector(
                onTap: (){
                  print(product.id);
                  Navigator.pushNamed(context, RouteNames.productDetailScreen,arguments: product.id);
                },
                child:  Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(product.thumbnail.toString()))
                        ),
                      ),
                    ),Text(product.title.toString(),style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                    Text("\$ ${product.price.toString()}",style: TextStyle(fontWeight: FontWeight.w300),)
                  ],
                ),

              )
,
              );
            });
          } else if (state is ProductsError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      );
}