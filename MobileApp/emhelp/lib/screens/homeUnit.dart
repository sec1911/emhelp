// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:emhelp/screens/emergencyDetails.dart';
import 'package:emhelp/screens/emergencyRequest.dart';
import 'package:emhelp/shared/failExit.dart';
import 'package:emhelp/widgets/emergencyCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart' as Api;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emhelp/shared/getName.dart' as getName;
import 'package:emhelp/shared/getToken.dart' as getToken;

class HomeUnit extends StatefulWidget {
  const HomeUnit({Key key}) : super(key: key);

  @override
  _HomeUnitState createState() => _HomeUnitState();
}

class _HomeUnitState extends State<HomeUnit> {
  @override
  void initState() {
    // TODO: implement initState
    getActiveEmergencies();
    getInactiveEmergencies();
    super.initState();
    getName.getName().then((result) {
      setState(() {
        if (result is String) _nameString = result.toString();
      });
    });
  }

  double axis = 500;

  String _nameString = "";

  List<dynamic> activeEmergencies;
  List<dynamic> inactiveEmergencies;

  ScaffoldMessengerState scaffoldMessenger;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Stack(children: [
        Image.asset(
          "assets/backgrounds/bg.png",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
          body: _selectedIndex == 0 && activeEmergencies != null
              ? buildGridViewForActives()
              : _selectedIndex == 1 && inactiveEmergencies != null
                  ? buildGridViewForInactives()
                  : Column(),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active_rounded),
                  label: "Active"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_off_rounded),
                  label: "Inactive"),
            ],
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffd36060),
            onTap: _onItemTapped,
          ),
        ),
      ]),
    );
  }

  GridView buildGridViewForActives() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: axis,
          childAspectRatio: 1.5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: activeEmergencies.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            child: EmergencyCard(
              incidentType: activeEmergencies[index]["incident_type"],
              message: activeEmergencies[index]["message"],
              openedByName: activeEmergencies[index]["opened_by"]["name"],
              dateCreated: activeEmergencies[index]["date_created"],
              index: index + 1,
              voiceRecording: activeEmergencies[index]["voice_recording"],
              emergencyId: activeEmergencies[index]["id"],
              state: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyDetails(
                        activeEmergencies[index]["incident_type"],
                        activeEmergencies[index]["message"],
                        activeEmergencies[index]["longitude"],
                        activeEmergencies[index]["latitude"],
                        activeEmergencies[index]["voice_recording"],
                        activeEmergencies[index]["opened_by"]["name"],
                        activeEmergencies[index]["seeker_blood_type"],
                        activeEmergencies[index]["seeker_conditions"],
                        activeEmergencies[index]["seeker_medications"],
                      ),
                    ),
                  );
                });
              },
            ),
          );
        });
  }

  GridView buildGridViewForInactives() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: axis,
          childAspectRatio: 1.5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: inactiveEmergencies.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            child: EmergencyCard(
              incidentType: inactiveEmergencies[index]["incident_type"],
              message: inactiveEmergencies[index]["message"],
              openedByName: inactiveEmergencies[index]["opened_by"]["name"],
              dateCreated: inactiveEmergencies[index]["date_created"],
              index: index + 1,
              state: () {
                setState(() {});
              },
            ),
          );
        });
  }

  Future<void> getActiveEmergencies() async {
    final token = await getToken.getToken();
    String AuthHeader = "Token " + token;

    final response = await http
        .get(Uri.parse(Api.baseUrl + "units/list-active-assigned"), headers: {
      HttpHeaders.authorizationHeader: AuthHeader,
      HttpHeaders.connectionHeader: "keep-alive",
    });

    if (response.statusCode == 200) {
      setState(() {
        activeEmergencies = jsonDecode(response.body);
      });
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
    }
  }

  Future<void> getInactiveEmergencies() async {
    final token = await getToken.getToken();
    String AuthHeader = "Token " + token;

    final response = await http
        .get(Uri.parse(Api.baseUrl + "units/list-inactive-assigned"), headers: {
      HttpHeaders.authorizationHeader: AuthHeader,
      HttpHeaders.connectionHeader: "keep-alive",
    });

    if (response.statusCode == 200) {
      setState(() {
        inactiveEmergencies = jsonDecode(response.body);
      });
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      for (var value in responseData.keys) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${responseData[value]}")));
      }
    }
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
