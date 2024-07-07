import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      'text': 'Lets Goo!',
      'subtitle':
          "Experience seamless and secure transactions with multiple payment options. Shop with confidence!"
    },
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: height * .9,
                width: width * .9,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        value = dotPosition;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Center(
                        child: _pages(
                            pages[index]['imageUrl'].toString(),
                            pages[index]['text'].toString(),
                            pages[index]['subtitle'].toString()),
                      );
                    })),
          ),
          DotsIndicator(
            position: dotPosition,
            dotsCount: 3,
          )
        ],
      ),
    );
  }
}

Widget _pages(String image, String Title, String subtitle) {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 300, width: 300, child: LottieBuilder.network(image)),
          Text(
            Title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 15, color: Colors.orange),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
