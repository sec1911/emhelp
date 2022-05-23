// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emhelp/shared/recordButton.dart';
import 'package:flutter/material.dart';
import 'package:emhelp/shared/getName.dart' as getName;
import 'package:http/http.dart' as http;
import 'package:emhelp/api/api.dart' as Api;
import 'package:emhelp/shared/getToken.dart' as getToken;
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';

class UnitList {
  String name;
  int index;
  UnitList({this.name, this.index});
}

class EmergencyRequest extends StatefulWidget {
  const EmergencyRequest({Key key}) : super(key: key);

  @override
  _EmergencyRequestState createState() => _EmergencyRequestState();
}

String unitType = "";
String incidentType = "";
Map<String, dynamic> locationData = {};
String audioPath = null;

class _EmergencyRequestState extends State<EmergencyRequest> {
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

  String message;
  TextEditingController messageController = TextEditingController();

  String radioItem = "";
  int id = 0;

  List<UnitList> uList = [
    UnitList(index: 1, name: "Police"),
    UnitList(index: 2, name: "Ambulance"),
    UnitList(index: 3, name: "Fire Fighter")
  ];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScaffoldMessengerState scaffoldMessenger;

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SafeArea(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(Icons.home_rounded),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Welcome " + _nameString),
            )
          ],
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Select any unit for emergency request",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
                Column(
                  children: uList
                      .map((data) => RadioListTile(
                            title: Text(
                              "${data.name}",
                              style: TextStyle(
                                  color: data.name == "Police"
                                      ? Color(0xff00b4e6)
                                      : data.name == "Ambulance"
                                          ? Colors.green
                                          : data.name == "Fire Fighter"
                                              ? Color(0xffd36060)
                                              : Colors.black54),
                            ),
                            groupValue: id,
                            value: data.index,
                            activeColor: data.name == "Police"
                                ? Color(0xff00b4e6)
                                : data.name == "Ambulance"
                                    ? Colors.green
                                    : data.name == "Fire Fighter"
                                        ? Color(0xffd36060)
                                        : Colors.white,
                            onChanged: (val) {
                              setState(() {
                                radioItem = data.name;
                                unitType = data.name == "Police"
                                    ? "police"
                                    : data.name == "Ambulance"
                                        ? "medic"
                                        : data.name == "Fire Fighter"
                                            ? "firefighter"
                                            : "None";
                                id = data.index;
                              });
                            },
                          ))
                      .toList(),
                ),
                radioItem == "Police"
                    ? QuickSelectPolice()
                    : radioItem == "Ambulance"
                        ? QuickSelectAmbulance()
                        : radioItem == "Fire Fighter"
                            ? QuickSelectFireFighter()
                            : Container(),
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                    controller: messageController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      hintText: "Enter your message",
                      hintStyle: TextStyle(color: Colors.black54),
                      isDense: true,
                    ),
                    onSaved: (value) {
                      message = value;
                    },
                    maxLength: 140,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25, bottom: 50),
                        child: ElevatedButton(
                          onPressed: () {
                            send(messageController.text, unitType, audioPath);
                          },
                          child: const Text(
                            "Send",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffd36060),
                              minimumSize: const Size(275, 50)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, bottom: 50),
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white24),
                            shape: BoxShape.circle,
                            color: Colors.white30),
                        child: RecordButton(
                            recordingFinishedCallback:
                                _recordingFinishedCallback),
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

  void _recordingFinishedCallback(String path) {
    final uri = Uri.parse(path);
    audioPath = uri.path;
  }

  send(message, unitType, audioPath) async {
    print(unitType);
    var request = http.MultipartRequest(
        "POST", Uri.parse(Api.baseUrl + "emergencies/add"));

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      request.fields['longitude'] = position.longitude.toString();
      request.fields['latitude'] = position.latitude.toString();
    });

    request.fields['incident_type'] = incidentType;
    request.fields['message'] = message;
    request.fields["unit_type"] = unitType;

    if (audioPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'voice_recording', audioPath,
          contentType: MediaType('audio', 'm4a')));
    }

    final token = await getToken.getToken();
    request.headers['Authorization'] = "Token " + token;

    await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 201) {
          scaffoldMessenger.showSnackBar(SnackBar(
              content: Text("You send your help request successfully.")));
          Navigator.pushReplacementNamed(context, "/home");
        } else if (response.statusCode == 400) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          for (var value in responseData.keys) {
            scaffoldMessenger.showSnackBar(
                SnackBar(content: Text("${value}: ${responseData[value]}")));
          }
        } else {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          for (var value in responseData.keys) {
            scaffoldMessenger.showSnackBar(
                SnackBar(content: Text("${value}: ${responseData[value]}")));
          }
        }
      });
    }).catchError((e) {
      print(e);
    });
  }
}

class QuickSelectPolice extends StatefulWidget {
  const QuickSelectPolice({Key key}) : super(key: key);

  @override
  _QuickSelectPoliceState createState() => _QuickSelectPoliceState();
}

class _QuickSelectPoliceState extends State<QuickSelectPolice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: 250,
      width: 340,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Other";
                });
              },
              child: const Text(
                "Other",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Theft Crimes";
                });
              },
              child: const Text(
                "Theft Crimes",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Homicide";
                });
              },
              child: const Text(
                "Homicide",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Assault";
                });
              },
              child: const Text(
                "Assault",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Domestic - Child Abuse";
                });
              },
              child: const Text(
                "Domestic - Child Abuse",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Kidnapping";
                });
              },
              child: const Text(
                "Kidnapping",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Terrorist Activity";
                });
              },
              child: const Text(
                "Terrorist Activity",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Rape";
                });
              },
              child: const Text(
                "Rape",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Vandalism";
                });
              },
              child: const Text(
                "Vandalism",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickSelectAmbulance extends StatefulWidget {
  const QuickSelectAmbulance({Key key}) : super(key: key);

  @override
  _QuickSelectAmbulanceState createState() => _QuickSelectAmbulanceState();
}

class _QuickSelectAmbulanceState extends State<QuickSelectAmbulance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: 250,
      width: 340,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Other";
                });
              },
              child: const Text(
                "Other",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Breathing Difficulty";
                });
              },
              child: const Text(
                "Breathing Difficulty",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Traffic Accident";
                });
              },
              child: const Text(
                "Traffic Accident",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Heart Attack";
                });
              },
              child: const Text(
                "Heart Attack",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Drowning";
                });
              },
              child: const Text(
                "Drowning",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickSelectFireFighter extends StatefulWidget {
  const QuickSelectFireFighter({Key key}) : super(key: key);

  @override
  _QuickSelectFireFighterState createState() => _QuickSelectFireFighterState();
}

class _QuickSelectFireFighterState extends State<QuickSelectFireFighter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: 250,
      width: 340,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Other";
                });
              },
              child: const Text(
                "Other",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Arson";
                });
              },
              child: const Text(
                "Arson",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Animal Rescue";
                });
              },
              child: const Text(
                "Animal Rescue",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Human Rescue";
                });
              },
              child: const Text(
                "Human Rescue",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Fire";
                });
              },
              child: const Text(
                "Fire",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Explosion";
                });
              },
              child: const Text(
                "Explosion",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Wildfire";
                });
              },
              child: const Text(
                "Wildfire",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  incidentType = "Earthquake";
                });
              },
              child: const Text(
                "Earthquake",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  primary: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
