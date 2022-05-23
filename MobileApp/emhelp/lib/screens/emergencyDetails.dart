import 'dart:async';

import 'package:emhelp/shared/audioPlayerMessage.dart';
import 'package:emhelp/shared/failExit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emhelp/shared/getName.dart' as getName;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:just_audio/just_audio.dart';
import 'package:emhelp/api/api.dart' as Api;

class EmergencyDetails extends StatefulWidget {
  final String incidentType;
  final String message;
  final String longitude;
  final String latitude;
  final String voiceRecording;
  final String openedByName;
  final String bloodType;
  final String specialConditions;
  final String medications;

  EmergencyDetails(
      this.incidentType,
      this.message,
      this.longitude,
      this.latitude,
      this.voiceRecording,
      this.openedByName,
      this.bloodType,
      this.specialConditions,
      this.medications);

  @override
  State<EmergencyDetails> createState() => _EmergencyDetailsState();
}

class _EmergencyDetailsState extends State<EmergencyDetails> {
  MapController _mapController = MapController();
  double _zoom = 14;
  List<Marker> _markers = [];

  @override
  void initState() {
    List<LatLng> _latLngList = [
      LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
    ];
    _markers = _latLngList
        .map(
          (point) => Marker(
            point: point,
            width: 15,
            height: 15,
            builder: (context) => Icon(
              Icons.pin_drop_rounded,
              size: 30,
              color: Colors.redAccent,
            ),
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
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
                  customItemsIndexes: const [3],
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
                    ...MenuItems.thirdItems.map(
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
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Informations"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('Seekers Name'),
                                  subtitle: widget.openedByName != null
                                      ? Text(widget.openedByName)
                                      : Text("None"),
                                  leading: Icon(Icons.push_pin_rounded),
                                ),
                                ListTile(
                                  title: Text('Seekers Message'),
                                  subtitle: widget.message != null
                                      ? Text(widget.message)
                                      : Text("None"),
                                  leading: Icon(Icons.push_pin_rounded),
                                ),
                                ListTile(
                                  title: Text('Seekers Blood Type'),
                                  subtitle: widget.bloodType != null
                                      ? Text(widget.bloodType)
                                      : Text("None"),
                                  leading: Icon(Icons.push_pin_rounded),
                                ),
                                ListTile(
                                  title: Text('Seekers Special Conditions'),
                                  subtitle: widget.specialConditions != null
                                      ? Text(widget.specialConditions)
                                      : Text("None"),
                                  leading: Icon(Icons.push_pin_rounded),
                                ),
                                ListTile(
                                  title: Text('Seekers Medications'),
                                  subtitle: widget.medications != null
                                      ? Text(widget.medications)
                                      : Text("None"),
                                  leading: Icon(Icons.push_pin_rounded),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, "OK"),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.info_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: widget.voiceRecording == null
                            ? Container()
                            : AudioPlayerMessage(
                                source: AudioSource.uri(
                                  Uri.parse(Api.baseUrl.substring(
                                          0, Api.baseUrl.length - 1) +
                                      widget.voiceRecording),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(
                  double.parse(widget.latitude),
                  double.parse(widget.longitude),
                ),
                zoom: _zoom,
                plugins: [MarkerClusterPlugin()],
              ),
              layers: [
                TileLayerOptions(
                  minZoom: 2,
                  maxZoom: 100,
                  backgroundColor: Colors.black,
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    disableClusteringAtZoom: 10,
                    size: Size(25, 25),
                    fitBoundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.all(20),
                    ),
                    markers: _markers,
                    builder: (context, markers) {
                      return Container();
                    }),
              ],
            ),
          ),
        ],
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
  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> secondItems = [settings];
  static const List<MenuItem> thirdItems = [logout];

  static const home = MenuItem(text: "Home", icon: Icons.home_rounded);
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
      case MenuItems.home:
        Navigator.pushReplacementNamed(context, '/homeunit');
        break;
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
