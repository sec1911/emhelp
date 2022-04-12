// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

var _loginStatus = 0;

Future<int> getLoginStat() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _loginStatus = preferences.getInt("loginStatus");

  return _loginStatus;
}
