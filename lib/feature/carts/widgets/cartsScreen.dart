import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:project_bloc/feature/carts/model/cart_model.dart';
import 'package:project_bloc/auth/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';

import 'package:project_bloc/feature/products/presentation/screen/product_details_screen.dart';


class CartsTab extends StatefulWidget {
  final User user;

  CartsTab({required this.user});

  @override
  _CartsTabState createState() => _CartsTabState();
}

class _CartsTabState extends State<CartsTab> {
  List<Product>? totalProducts;
  UserCartResponse? _cart;
  double _total = 0.0;
  double _discountedTotal = 0.0;
  int _totalQuatity =0;
  int? _userId;
  int? totalproducts;

  @override
  void initState() {
    super.initState();

    String? json = SharedPreferenecesService.getString(key: "userCarts");
 if ( json != null) {

     UserCartResponse carts = UserCartResponse.fromJson(jsonDecode(json!));
    _cart = carts;
   
 }else{
  throw Exception(
    
  );
 }

    setState(() {
      List<Product> totalProduct = _cart!.carts.expand((cart) => cart.products).toList();
      totalProducts = totalProduct;
      _updateTotals();
    });
  }

  void _updateCart(Product product, int quantityChange) {
    if (_cart == null) return;

    Cart? userCart = _cart!.carts.firstWhere((cart) => cart.userId == widget.user.id);

    if (userCart != null) {
      Product? cartProduct = userCart.products.firstWhere((p) => p.id == product.id);

      if (cartProduct != null) {
        cartProduct.quantity = (cartProduct.quantity ?? 0) + quantityChange;
        if (cartProduct.quantity! <= 0) {
          userCart.products.remove(cartProduct);
          setState(() {
            
          });
        }
      } else {
        product.quantity = quantityChange;
        userCart.products.add(product);
      }

      userCart.total = userCart.products.fold(0, (sum, p) => sum + (p.price * (p.quantity ?? 1)));
      userCart.totalQuantity = userCart.products.fold(0, (sum, p) => sum + (p.quantity ?? 1));
userCart.discountedTotal = userCart.products.fold(0, (sum, p)=>sum + (p.total *p.discountPercentage/100) );

      final updatedCartJson = _cart!.toJson();
      SharedPreferenecesService.setString(key: "userCarts", value: jsonEncode(updatedCartJson));
      _updateTotals();
    }
    setState(() {});
  }

  void _updateTotals() {
    if (_cart == null) return;

    Cart? userCart = _cart!.carts.firstWhere((cart) => cart.userId == widget.user.id);

    if (userCart != null) {
      _total = userCart.total;
      
      _discountedTotal = userCart.total - userCart.discountedTotal;
      _totalQuatity = userCart.totalQuantity;
      _userId = userCart.userId;
    totalproducts = userCart.products.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCart = _cart!.carts.firstWhere((c)=> c.userId == widget.user.id);
    return Scaffold(
      appBar: AppBar(title: Text("My Cart",style: TextStyle(fontWeight: FontWeight.bold),),),
      body:_cart!.carts[0].products.isEmpty ||  _cart!.carts[0].products   == null
                ? Center(child: Text('Your cart is empty',style: TextStyle(fontSize: 15.sp),))
                :  SingleChildScrollView(
        child: Stack(
          children: [
             Column(
                  children: [
                    StatefulBuilder(
                      builder: (context,setState) {
                        return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5, 
                              crossAxisCount: 2,
                            ),
                            itemCount: totalProducts!.length,
                            itemBuilder: (context, index) {
                              final product = totalProducts![index];
                        
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 40,),
                                          Text("Quantity: ${product.quantity.toString()}",style: 
                                          TextStyle(color: Colors.orange),),
                                          SizedBox(width: 10,),
                                          IconButton(
                                            onPressed: () {
                                             setState((){
                                               _updateCart(product, 1);
                                             });
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(product.thumbnail.toString()))),
                                        ),
                                      ),
                                      Text(
                                        product.title.toString(),
                                        style: TextStyle(fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 50,),
                                          Text(
                                            "\$ ${product.price.toString()}",
                                            style: TextStyle(fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(width: 20,),
                                          IconButton(
                                            onPressed: () {
                                           setState((){
                                               _updateCart(product, -1);
                                               setState((){});
                                           });
                                            },
                                            icon: Icon(Icons.remove),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    ),
                      SizedBox(height: 20,),
                  _cart!.carts[0].products.isEmpty ||  _cart!.carts[0].products  == null ? SizedBox.shrink():      Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
            
                children: [
                  Text(
                    'Total: \$${userCart.total.truncate()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Discounted Total: \$${_discountedTotal.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                   Text(
                    'TotalProducts: $totalproducts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'TotalQuantity: $_totalQuatity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                Text(
                    'UserId: $_userId',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
                  ],
                ),
           
          ],
        ),
      ),
    );
  }
}
