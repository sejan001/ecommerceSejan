
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project_bloc/auth/bloc/auth_bloc.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPass = true;
  List<String> dropDownItems = [
    "Course Categories",
    "Top Courses",
    "Popular Courses"
  ];

  bool isDark = false;

  @override
  clear() {
    _username.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          Center(
              child: Container(
            height: height * .1,
            child: LottieBuilder.network(
                "https://lottie.host/63f09589-a540-4e4d-89cc-b50c59978a5e/t6tMUb4x2i.json"),
          ));
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              state.error,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else if (state is AuthSuccess) {
          final userJson = jsonEncode(state.user.toJson());
          context.go("/homeScreen/${Uri.encodeComponent(userJson)}");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("logged in"),backgroundColor: Colors.green,));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text("Login",
                        style: GoogleFonts.getFont(
                          'Roboto',
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Container(
                    height: height * .2,
                    width: width * .5,
                    child: LottieBuilder.network(
                        "https://lottie.host/e0e71f8a-4cf1-4ef5-bc01-bbd8c6534393/ebqVYKldpL.json"),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: width * .7,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              validator: (value) {
                                if (value!.length > 100) {
                                  return "Cant have more than 10 letters";
                                }
                                if (value.length <= 0 || value.isEmpty) {
                                  return "Enter a username";
                                }
                              },
                              controller: _username,
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      color: Colors.black,
                                      onPressed: null,
                                      icon: Icon(null)),
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  labelText: "Enter  Username"),
                            ),
                          ),
                          SizedBox(height: height * .01),
                          Container(
                            width: width * .7,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              obscureText: _showPass,
                              validator: (value) {
                                if (value!.length > 100) {
                                  return "Cant have more than 10 letters";
                                }
                                if (value!.length <= 0 || value.isEmpty) {
                                  return "Enter a password";
                                }
                              },
                              controller: _password,
                              decoration: InputDecoration(
                                  suffixIconColor: Colors.blue,
                                  suffix: IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        setState(() {
                                          _showPass = !_showPass;
                                        });
                                      },
                                      icon: Icon(Icons.remove_red_eye)),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  labelText: "Enter Password"),
                            ),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 232, 209, 2)),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                          LoginButtonPressedEvent(
                                              username: _username.text,
                                              password: _password.text));
                                      clear();


                                    }
                                  },
                                  child: Text("Login",
                                      style: GoogleFonts.getFont('Roboto',
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 235, 241, 247),
                                          )))),
                            ],
                          ),
                          SizedBox(width: width * .05)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
