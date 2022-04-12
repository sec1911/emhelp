// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:emhelp/shared/getUserRole.dart' as getUserRole;
import 'package:flutter/material.dart';
import 'package:emhelp/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart' as Api;
import 'package:emhelp/shared/getDetails.dart' as getDetails;

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic> _userData = {};
  var _role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails.getDetails().then((result) {
      setState(() {
        if (result is String) _userData = jsonDecode(result);
      });
    });

    getUserRole.getUserRole().then((result) {
      setState(() {
        if (result is String) _role = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Account Details"),
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
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                child: Icon(Icons.edit_rounded),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/editprofile');
                },
              ),
            ),
          ],
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
          child: ListView(
            padding: EdgeInsets.all(25),
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Image(
                  image: AssetImage("assets/backgrounds/user_icon.png"),
                  height: 100,
                ),
              ),
              ListTile(
                title: Text('E-mail'),
                subtitle: _userData["email"] != null
                    ? Text(_userData["email"])
                    : Text("None"),
                leading: Icon(Icons.email_rounded),
              ),
              ListTile(
                title: Text('Name'),
                subtitle: _userData["first_name"] != null &&
                        _userData["last_name"] != null
                    ? Text(
                        _userData["first_name"] + " " + _userData["last_name"])
                    : Text("None"),
                leading: Icon(Icons.person_rounded),
              ),
              ListTile(
                title: Text('Date of Birth'),
                subtitle: _userData["date_of_birth"] != null
                    ? Text(_userData["date_of_birth"])
                    : Text("None"),
                leading: Icon(Icons.calendar_today_rounded),
              ),
              ListTile(
                title: Text('Blood Type'),
                subtitle: _userData["blood_type"] != null
                    ? Text(_userData["blood_type"])
                    : Text("None"),
                leading: Icon(Icons.bloodtype_rounded),
              ),
              ListTile(
                title: Text('Social Security Number'),
                subtitle: _userData["social_security_number"] != null
                    ? Text(_userData["social_security_number"])
                    : Text("None"),
                leading: Icon(Icons.perm_identity_rounded),
              ),
              ListTile(
                title: Text('Special Conditions'),
                subtitle: _userData["special_conditions"] != null
                    ? Text(_userData["special_conditions"])
                    : Text("None"),
                leading: Icon(Icons.health_and_safety_rounded),
              ),
              ListTile(
                title: Text('Medications'),
                subtitle: _userData["medications"] != null
                    ? Text(_userData["medications"])
                    : Text("None"),
                leading: Icon(Icons.medication_rounded),
              ),
              ListTile(
                title: Text('Phone Number'),
                subtitle: _userData["phone_number"] != null
                    ? Text(_userData["phone_number"])
                    : Text("None"),
                leading: Icon(Icons.phone_android_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
