import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:emhelp/api/api.dart' as Api;
import 'package:emhelp/shared/getToken.dart' as getToken;
import 'package:http/http.dart' as http;

class EmergencyCard extends StatelessWidget {
  final String incidentType;
  final String message;
  final String openedByName;
  final String dateCreated;
  final Function state;
  final int index;
  final String voiceRecording;
  final int emergencyId;

  EmergencyCard(
      {this.incidentType,
      this.message,
      this.openedByName,
      this.dateCreated,
      this.state,
      this.index,
      this.voiceRecording,
      this.emergencyId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Center(
        child: TextButton(
          onPressed: state,
          child: Card(
            elevation: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 4,
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(0.50)),
                ),
              ),
              height: 300,
              width: 350,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Incident Type: " + incidentType,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                      child: Text(
                        message.length > 100
                            ? message.substring(0, 99) + "..."
                            : message,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(children: [
                      Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        openedByName,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 6, 0, 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_send_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          dateCreated,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: closeEmergency,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          color: Color(0xffd36060),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Close Emergency",
                          style: TextStyle(
                            color: Color(0xffd36060),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  closeEmergency() async {
    final token = await getToken.getToken();
    String AuthHeader = "Token " + token;
    final response = await http.post(
      Uri.parse(Api.baseUrl + "emergencies/$emergencyId/close-emergency"),
      headers: {
        HttpHeaders.authorizationHeader: AuthHeader,
      },
    );
  }
}
