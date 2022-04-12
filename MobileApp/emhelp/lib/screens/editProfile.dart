import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:emhelp/screens/register.dart';
import 'package:emhelp/shared/getToken.dart';
import 'package:flutter/material.dart';
import 'package:emhelp/shared/getToken.dart' as getToken;
import 'package:emhelp/api/api.dart' as Api;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emhelp/shared/getUserRole.dart' as getUserRole;

String email, phoneNo, specialConditions, medications;
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

TextEditingController emailController = TextEditingController();
TextEditingController phoneNoController = TextEditingController();
TextEditingController specialConditionsController = TextEditingController();
TextEditingController medicationsController = TextEditingController();

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserRole.getUserRole().then((result) {
      setState(() {
        if (result is String) _role = result;
      });
    });
  }

  bool emailCheck,
      phoneNoCheck,
      specialConditionsCheck,
      medicationsCheck = false;
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Edit Profile"),
          leading: InkWell(
            child: Icon(Icons.home_rounded),
            onTap: () {
              if (_role == "none") {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (_role == "police" ||
                  _role == "medic" ||
                  _role == "firefighter") {
                Navigator.pushReplacementNamed(context, '/homeunit');
              }
            },
          ),
          centerTitle: true,
          backgroundColor: Color(0xffd36060),
        ),
        body: Container(
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
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        primary:
                            emailCheck == true ? Colors.green : Colors.red),
                    child: emailCheck == true
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.cancel_rounded),
                    onPressed: () {
                      setState(() {
                        if (emailCheck == true) {
                          emailCheck = false;
                        } else {
                          emailCheck = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextFormField(
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
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary:
                            phoneNoCheck == true ? Colors.green : Colors.red),
                    child: phoneNoCheck == true
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.cancel_rounded),
                    onPressed: () {
                      setState(() {
                        if (phoneNoCheck == true) {
                          phoneNoCheck = false;
                        } else {
                          phoneNoCheck = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextFormField(
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
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: specialConditionsCheck == true
                            ? Colors.green
                            : Colors.red),
                    child: specialConditionsCheck == true
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.cancel_rounded),
                    onPressed: () {
                      setState(() {
                        if (specialConditionsCheck == true) {
                          specialConditionsCheck = false;
                        } else {
                          specialConditionsCheck = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                      controller: specialConditionsController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        hintText: "Special Conditions",
                        hintStyle: TextStyle(color: Colors.black54),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: medicationsCheck == true
                            ? Colors.green
                            : Colors.red),
                    child: medicationsCheck == true
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.cancel_rounded),
                    onPressed: () {
                      setState(() {
                        if (medicationsCheck == true) {
                          medicationsCheck = false;
                        } else {
                          medicationsCheck = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                      controller: medicationsController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        hintText: "Medications",
                        hintStyle: TextStyle(color: Colors.black54),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      updateInfo(
                          emailController.text,
                          phoneNoController.text,
                          specialConditionsController.text,
                          medicationsController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.red[300],
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        "Update",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateInfo(email, phoneNo, specialConditions, medications) async {
    Map info = {};

    if (emailCheck == true) {
      info["email"] = email;
    }
    if (phoneNoCheck == true) {
      info["phone_number"] = phoneNo;
    }
    if (specialConditionsCheck == true) {
      info["special_conditions"] = specialConditions;
    }
    if (medicationsCheck == true) {
      info["medications"] = medications;
    }

    final token = await getToken.getToken();
    String AuthHeader = "Token " + token;
    final response = await http.post(
      Uri.parse(Api.baseUrl + "users/account/update"),
      headers: {
        HttpHeaders.authorizationHeader: AuthHeader,
      },
      body: info,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      savePref(1, responseData);
      emailController.clear();
      phoneNoController.clear();
      specialConditionsController.clear();
      medicationsController.clear();
      if (_role == "none") {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (_role == "police" ||
          _role == "medic" ||
          _role == "firefighter") {
        Navigator.pushReplacementNamed(context, '/homeunit');
      }
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      for (var value in responseData.keys) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("${value}: ${responseData[value]}")));
      }
    }
  }

  savePref(int _loginStatus, Map<String, dynamic> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("email", data['email']);
    preferences.setString("phone_number", data['phone_number']);
    preferences.setString("special_conditions", data['special_conditions']);
    preferences.setString("medications", data['medications']);
  }
}
