import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_bloc.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_events.dart';
import 'package:project_bloc/feature/products/Products/Bloc/products_state.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';
import 'package:project_bloc/feature/products/domain/model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final id;

  const ProductDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;
  bool isVisible = true;
  bool showAnimation = true;

  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(context)
        .add(FetchProducts(filterModel: FilterProductStateModel()));
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Product Detail'),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
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
            final product = state.products.firstWhere(
                (e) => e.id.toString() == widget.id.toString(),
                orElse: () => Products());
            if (product == null) {
              return Center(child: Text('Product not found'));
            }

            String? barcodeDate = product.meta?.barcode ?? '';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      height: height * 0.3,
                      width: width * 0.9,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: product.images!.length,
                        itemBuilder: (context, index) {
                          final image = product.images![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(image),
                          );
                        },
                      ),
                    ),
                    DotsIndicator(
                      decorator: DotsDecorator(
                        color: Colors.grey,
                        activeColor: Color.fromARGB(255, 38, 240, 240),
                      ),
                      dotsCount: product.images!.length,
                      position: _currentPage.toInt(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${product.rating.toString()}🌟"),
                        SizedBox(width: width * 0.09),
                        Text(
                          product.title.toString(),
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Price : \$ ${product.price.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            backgroundColor: Color.fromARGB(255, 92, 243, 22),
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showAnimation = !showAnimation;
                            });
                          },
                          child: Text(
                            "More Info",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 14, 225, 253),
                                width: 3,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Product Info",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Text(
                                    "Stock : ${product.stock}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "${product.tags}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "Brand: ${product.brand}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "Weight: ${product.weight}kg",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "Height: ${product.dimensions!.height.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "Width: ${product.dimensions!.width.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  Text(
                                    "Depth: ${product.dimensions!.depth.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: isVisible,
                              child: showAnimation
                                  ? Container(
                                      height: height * 0.3,
                                      width: width * 0.2,
                                      child: LottieBuilder.network(
                                          "https://lottie.host/6ced5ea9-fb13-4896-bbc3-bbd1045856f5/DXASE1qhX4.json"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TyperAnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        speed: Duration(milliseconds: 10),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        text: [product.description.toString()],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: height * 0.4,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Reviews",
                                style: TextStyle(
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: product.reviews!.length,
                                itemBuilder: (context, index) {
                                  final review = product.reviews![index];
                                  return Card(
                                    color: Colors.white54,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Column(
                                            children: [
                                              Text(
                                                "@ ${review.reviewerName.toString()}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.cyan,
                                                ),
                                              ),
                                              Text(
                                                review.reviewerEmail.toString(),
                                                style: TextStyle(fontSize: 9),
                                              ),
                                            ],
                                          ),
                                          trailing: Text(
                                            "${review.rating.toString()}/5🌟",
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${review.comment.toString()}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.08),
                                        Text(
                                          review.date.toString(),
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Return Info",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "Time : ${product.returnPolicy}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.cyan,
                              ),
                            ),
                            Text(
                              "Min.Orderquantity : ${product.minimumOrderQuantity}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        children: [
                          Text(
                            "Scan For More Info",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.orange,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.2,
                                child: Image.network(
                                    product.meta!.qrCode.toString()),
                              ),
                              SizedBox(width: width * 0.1),
                              Container(
                                  width: width * 0.3,
                                  child: BarcodeWidget(
                                      data: barcodeDate!,
                                      barcode: Barcode.code128())),
                            ],
                          ),
                          Text(
                            "created at : ${product.meta!.createdAt}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 223, 20, 30),
                            ),
                          ),
                          Text(
                            "updated at : ${product.meta!.updatedAt}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 223, 20, 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProductsError) {
            return Center(child: Text(state.error.toString()));
          } else {
            return Center(child: Text("Error finding product"));
          }
        },
      ),
    );
  }
}
