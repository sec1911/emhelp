// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

String _userRole = "";

Future<String> getUserRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _userRole = preferences.getString("user_role");

  return _userRole;
}
