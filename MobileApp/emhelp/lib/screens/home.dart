import 'dart:convert';
import 'dart:io';

import 'package:emhelp/screens/emergencyRequest.dart';
import 'package:emhelp/shared/failExit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart' as Api;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emhelp/shared/getName.dart' as getName;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName.getName().then((result) {
      setState(() {
        if (result is String) _nameString = result.toString();
      });
    });
  }

  String _nameString = "";

  bool isLoading = false;

  ScaffoldMessengerState scaffoldMessenger;

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffd36060),
          leading: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.list,
                size: 46,
                color: Colors.white,
              ),
              customItemsIndexes: const [2],
              customItemsHeight: 8,
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                ...MenuItems.secondItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 50,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 200,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xffd36060),
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 0),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Welcome " + _nameString),
            )
          ],
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
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 200),
                  height: 200,
                  width: 200,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/emergencyrequest');
                    },
                    backgroundColor: Color(0xffd36060),
                    foregroundColor: Colors.white,
                    child: const Icon(
                      Icons.call_rounded,
                      size: 125,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 175),
                  child: const Text(
                    "Tap button for emergency request",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({this.text, this.icon});
}

class MenuItems {
  static const List<MenuItem> firstItems = [settings];
  static const List<MenuItem> secondItems = [logout];

  static const settings =
      MenuItem(text: "Account Details", icon: Icons.settings);
  static const logout = MenuItem(text: "Logout", icon: Icons.logout_rounded);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) async {
    switch (item) {
      case MenuItems.settings:
        Navigator.pushReplacementNamed(context, '/account');
        break;
      case MenuItems.logout:
        failExit();
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }
}
