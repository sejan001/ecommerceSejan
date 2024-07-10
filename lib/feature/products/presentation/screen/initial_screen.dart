import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/feature/products/domain/model/user_model.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  var dotPosition = 0;
  final List<Map<String, String>> pages = [
    {
      'imageUrl':
          'https://lottie.host/471bb32d-c089-4273-887f-9b51cc61f97d/sCOz0Znzdc.json',
      'text': 'Hello Amazing Shoper!',
      'subtitle':
          "Find the best discounts on your favorite products. Shop now and save big on top brands!"
    },
    {
      'imageUrl':
          "https://lottie.host/7b54919e-70fe-444c-ba54-91f70b3746be/oHjor1Z91l.json",
      'text': 'Welcome to SejanFY',
      'subtitle':
          "Find the best discounts on your favorite products. Shop now and save big on top brands!"
    },
    {
      'imageUrl':
          'https://lottie.host/35f9b231-9f9a-4d3a-9711-c3687ef39794/WrL29uGXSt.json',
      'text': 'Explore!',
      'subtitle':
          "Experience seamless and secure transactions with multiple payment options. Shop with confidence!"
    },
  ];
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    final token = await SharedPreferenecesService.getString(key: 'token');
    final userJson =
        await SharedPreferenecesService.getString(key: "currentUser");

    if (token != null && userJson != null) {
      final user = User.fromJson(jsonDecode(userJson));
      GoRouter.of(context)
          .go("/homeScreen/${Uri.encodeComponent(jsonEncode(user.toJson()))}");
    } else {
      GoRouter.of(context).go("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                  child: TextButton(
                      onPressed: () {
                        context.go("/login");
                      },
                      child: Text(
                        "skip",
                        style: TextStyle(fontSize: 17, color: Colors.pink),
                      )))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: height * .7,
                width: width * .9,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        dotPosition = value;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Center(
                        child: _pages(
                            pages[index]['imageUrl'].toString(),
                            pages[index]['text'].toString(),
                            pages[index]['subtitle'].toString(),
                            height,
                            width),
                      );
                    })),
          ),
          Center(
            child: DotsIndicator(
              decorator: DotsDecorator(activeColor: Colors.orange),
              position: dotPosition,
              dotsCount: 3,
            ),
          ),
          if (dotPosition == 2)
            Center(
                child: TextButton(
              onPressed: () {
                context.go("/login");
              },
              child: Text(
                "Lets Go!",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              style: ButtonStyle(
                  fixedSize:
                      WidgetStatePropertyAll(Size(width * .6, height * .09))),
            )),
        ],
      ),
    );
  }
}

Widget _pages(
  String image,
  String Title,
  String subtitle,
  double width,
  double height,
) {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: height * .6,
              width: width * .8,
              child: LottieBuilder.network(image)),
          Text(
            Title,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 25,
                decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: height * .05,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
