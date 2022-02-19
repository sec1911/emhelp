import 'package:emhelp/accountDetails.dart';
import 'package:emhelp/login.dart';
import 'package:flutter/material.dart';
import 'package:emhelp/home.dart';
import 'package:emhelp/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Emhelp());
}

class Emhelp extends StatefulWidget {
  const Emhelp({Key key}) : super(key: key);

  @override
  _EmhelpState createState() => _EmhelpState();
}

class _EmhelpState extends State<Emhelp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  var _loginStatus = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SanFrancisco'),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [(_loginStatus == 1) ? Home() : Login()],
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => Register(),
        '/registercont': (BuildContext context) => RegisterCont(),
        '/account': (BuildContext context) => Account(),
      },
    );
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("loginStatus");
    });
  }
}
