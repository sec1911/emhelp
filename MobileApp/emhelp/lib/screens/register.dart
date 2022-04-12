// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:emhelp/shared/failExit.dart';
import 'package:flutter/material.dart';
import '../api/api.dart' as Api;
import 'package:emhelp/screens/login.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

final _formKey = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();

String email,
    password,
    confirmPassword,
    firstName,
    lastName,
    socialSecNo,
    bloodType,
    dateOfBirth,
    phoneNo;

bool isLoading = false;

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
ScaffoldMessengerState scaffoldMessenger;

GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey();
ScaffoldMessengerState scaffoldMessenger2;

var reg = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController socialSecNoController = TextEditingController();
TextEditingController bloodTypeController = TextEditingController();
TextEditingController dateOfBirthController = TextEditingController();
TextEditingController phoneNoController = TextEditingController();

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/backgrounds/bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 50, top: 50),
                      child: Image(
                        image: AssetImage("assets/backgrounds/icon.png"),
                        height: 100,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      transform: Matrix4.translationValues(0, -10, 0),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                            letterSpacing: 8,
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
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
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: passwordController,
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
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                confirmPassword = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: firstNameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "First Name",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                firstName = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: lastNameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Last Name",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                lastName = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/registercont');
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Text(
                            "Already have an account?",
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
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
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
    );
  }
}

class RegisterCont extends StatefulWidget {
  const RegisterCont({Key key}) : super(key: key);

  @override
  _RegisterContState createState() => _RegisterContState();
}

class _RegisterContState extends State<RegisterCont> {
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger2 = ScaffoldMessenger.of(context);
    return Scaffold(
      key: scaffoldKey2,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/backgrounds/bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 50, top: 50),
                      child: Image(
                        image: AssetImage("assets/backgrounds/icon.png"),
                        height: 100,
                      ),
                    ),
                    Form(
                      key: _formKey2,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: socialSecNoController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Social Security Number",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                socialSecNo = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: bloodTypeController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Blood Type",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                bloodType = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: dateOfBirthController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Date of Birth YYYY-MM-DD",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                dateOfBirth = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                              controller: phoneNoController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                hintText: "Phone Number",
                                hintStyle: TextStyle(color: Colors.black54),
                                isDense: true,
                              ),
                              onSaved: (value) {
                                phoneNo = value;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isLoading) {
                                      return;
                                    }
                                    register(
                                        emailController.text,
                                        passwordController.text,
                                        confirmPasswordController.text,
                                        firstNameController.text,
                                        lastNameController.text,
                                        socialSecNoController.text,
                                        bloodTypeController.text,
                                        dateOfBirthController.text,
                                        phoneNoController.text);
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
                                      "Register",
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
                                              height: 8,
                                              width: 8,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.green,
                                              )))
                                      : Container(),
                                  right: 4,
                                  bottom: 0,
                                  top: 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(50),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/register');
                            },
                            child: Text(
                              "Go back to Register",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              "Go back to Login",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
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
    );
  }

  changeIsLoading() {
    setState(() {
      isLoading = false;
    });
  }

  register(email, password, confirmPassword, firstName, lastName, socialSecNo,
      bloodType, dateOfBirth, phoneNo) async {
    Map data = {
      'email': email,
      'password1': password,
      'password2': confirmPassword,
      'first_name': firstName,
      'last_name': lastName,
      'social_security_number': socialSecNo,
      'blood_type': bloodType,
      'date_of_birth': dateOfBirth,
      "phone_number": phoneNo
    };

    final response =
        await http.post(Uri.parse(Api.register), headers: {}, body: data);

    changeIsLoading();

    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      String AuthHeader = "Token " + responseData['key'];

      final detailResponse = await http.get(Uri.parse(Api.accountDetails),
          headers: {HttpHeaders.authorizationHeader: AuthHeader});

      if (detailResponse.statusCode == 200) {
        Map<String, dynamic> detailResponseData =
            jsonDecode(detailResponse.body);

        savePref(1, responseData['key'], detailResponseData);
      } else if (detailResponse.statusCode == 401) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text("Login failed, please contact with system admin")));
        failExit();
        Navigator.pushReplacementNamed(context, '/register');
      }
      Navigator.pushReplacementNamed(context, '/home');
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      for (var value in responseData.keys) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("${value}: ${responseData[value]}")));
      }
      failExit();
      Navigator.pushReplacementNamed(context, '/register');
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      for (var value in responseData.keys) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("${value}: ${responseData[value]}")));
      }
      failExit();
      Navigator.pushReplacementNamed(context, '/register');
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
    preferences.setString("phone_number", detail['phone_number']);
    preferences.setString("special_conditions", detail['special_conditions']);
    preferences.setString("medications", detail['medications']);
    preferences.setString(
        "social_security_number", detail['social_security_number']);
    preferences.setString("last_login", detail['last_login']);
    preferences.setString("user_role", detail['user_role']);
  }
}
