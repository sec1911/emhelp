import 'package:emhelp/screens/accountDetails.dart';
import 'package:emhelp/screens/editProfile.dart';
import 'package:emhelp/screens/emergencyRequest.dart';
import 'package:emhelp/screens/homeUnit.dart';
import 'package:emhelp/screens/login.dart';
import 'package:emhelp/shared/getLoginStat.dart' as getLoginStat;
import 'package:emhelp/shared/getUserRole.dart' as getUserRole;
import 'package:flutter/material.dart';
import 'package:emhelp/screens/home.dart';
import 'package:emhelp/screens/register.dart';

void main() {
  runApp(const Emhelp());
}

class Emhelp extends StatefulWidget {
  const Emhelp({Key key}) : super(key: key);

  @override
  _EmhelpState createState() => _EmhelpState();
}

var _loginStatus = 0;
var _role = "";

class _EmhelpState extends State<Emhelp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginStat.getLoginStat().then((result) {
      setState(() {
        if (result is int) _loginStatus = result;
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
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SanFrancisco'),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          (_loginStatus == 1 && _role == "none")
              ? Home()
              : (_loginStatus == 1 &&
                      (_role == "police" ||
                          _role == "medic" ||
                          _role == "firefighter"))
                  ? HomeUnit()
                  : Login(),
        ],
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => Register(),
        '/registercont': (BuildContext context) => RegisterCont(),
        '/account': (BuildContext context) => Account(),
        '/emergencyrequest': (BuildContext context) => EmergencyRequest(),
        '/homeunit': (BuildContext context) => HomeUnit(),
        '/editprofile': (BuildContext context) => EditProfile(),
      },
    );
  }
}
