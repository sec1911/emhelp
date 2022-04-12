// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:emhelp/shared/failExit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api/api.dart' as Api;
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email, password;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScaffoldMessengerState scaffoldMessenger;

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/backgrounds/bg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 75),
                        child: Image(
                          image: AssetImage("assets/backgrounds/icon.png"),
                          height: 100,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        transform: Matrix4.translationValues(0, -20.0, 0.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              letterSpacing: 8,
                              color: Colors.black45,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle),
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.center,
                              controller: emailController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "E-mail",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                email = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: true,
                              style: TextStyle(color: Colors.black54),
                              controller: passwordController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                password = value;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isLoading) {
                                      return;
                                    }
                                    // if (emailController.text.isEmpty ||
                                    //     passwordController.text.isEmpty) {
                                    //   scaffoldMessenger.showSnackBar(SnackBar(
                                    //       content:
                                    //           Text("Please fill all fields!")));
                                    //   return;
                                    // }
                                    login(emailController.text,
                                        passwordController.text);
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red[300],
                                        border:
                                            Border.all(color: Colors.black54),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(
                                      "Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: (isLoading)
                                      ? Center(
                                          child: Container(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.green,
                                              )))
                                      : Container(),
                                  right: 10,
                                  bottom: 0,
                                  top: 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/register');
                              },
                              child: Text(
                                "REGISTER",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login(email, password) async {
    Map data = {'email': email, 'password': password};

    final response = await http.post(
      Uri.parse(Api.login),
      headers: {},
      body: data,
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      String AuthHeader = "Token " + responseData['key'];

      final detailResponse = await http.get(Uri.parse(Api.accountDetails),
          headers: {HttpHeaders.authorizationHeader: AuthHeader});

      if (detailResponse.statusCode == 200) {
        Map<String, dynamic> detailResponseData =
            jsonDecode(detailResponse.body);

        savePref(1, responseData['key'], detailResponseData);

        if (detailResponseData["user_role"] == "none") {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (detailResponseData["user_role"] == "police" ||
            detailResponseData["user_role"] == "medic" ||
            detailResponseData["user_role"] == "firefighter") {
          Navigator.pushReplacementNamed(context, '/homeunit');
        }
      } else if (detailResponse.statusCode == 401) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text("Login failed, please contact with system admin")));
        failExit();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  savePref(int _loginStatus, String key, Map<String, dynamic> detail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("loginStatus", _loginStatus);
    preferences.setString("key", key);
    preferences.setString("email", detail['email']);
    preferences.setString("first_name", detail['first_name']);
    preferences.setString("last_name", detail['last_name']);
    preferences.setString("date_of_birth", detail['date_of_birth']);
    preferences.setString("blood_type", detail['blood_type']);
    preferences.setString("special_conditions", detail['special_conditions']);
    preferences.setString("medications", detail['medications']);
    preferences.setString(
        "social_security_number", detail['social_security_number']);
    preferences.setString("last_login", detail['last_login']);
    preferences.setString("user_role", detail['user_role']);
    preferences.setString("phone_number", detail['phone_number']);
  }
}
