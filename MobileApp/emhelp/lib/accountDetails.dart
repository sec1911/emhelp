// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:emhelp/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart' as Api;

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      data = {
        "email": preferences.getString("email"),
        "first_name": preferences.getString("first_name"),
        "last_name": preferences.getString("last_name"),
        "date_of_birth": preferences.getString("date_of_birth"),
        "blood_type": preferences.getString("blood_type"),
        "social_security_number":
            preferences.getString("social_security_number"),
        "special_conditions": preferences.getString("special_conditions"),
        "medications": preferences.getString("medications"),
      };
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
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                child: Icon(Icons.edit_rounded),
                onTap: () {},
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
                subtitle: Text(data["email"]),
                leading: Icon(Icons.email_rounded),
              ),
              ListTile(
                title: Text('Name'),
                subtitle: Text(data["first_name"] + " " + data["last_name"]),
                leading: Icon(Icons.person_rounded),
              ),
              ListTile(
                title: Text('Date of Birth'),
                subtitle: Text(data["date_of_birth"]),
                leading: Icon(Icons.calendar_today_rounded),
              ),
              ListTile(
                title: Text('Blood Type'),
                subtitle: Text(data["blood_type"]),
                leading: Icon(Icons.bloodtype_rounded),
              ),
              ListTile(
                title: Text('Social Security Number'),
                subtitle: Text(data["social_security_number"]),
                leading: Icon(Icons.perm_identity_rounded),
              ),
              ListTile(
                title: Text('Special Conditions'),
                subtitle: Text(data["special_conditions"]),
                leading: Icon(Icons.health_and_safety_rounded),
              ),
              ListTile(
                title: Text('Medications'),
                subtitle: Text(data["medications"]),
                leading: Icon(Icons.medication_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
