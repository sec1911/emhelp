// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _userData = {};

Future<String> getDetails() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  _userData = {
    "email": preferences.getString("email"),
    "first_name": preferences.getString("first_name"),
    "last_name": preferences.getString("last_name"),
    "date_of_birth": preferences.getString("date_of_birth"),
    "blood_type": preferences.getString("blood_type"),
    "social_security_number": preferences.getString("social_security_number"),
    "special_conditions": preferences.getString("special_conditions"),
    "medications": preferences.getString("medications"),
    "user_role": preferences.getString("user_role"),
    "phone_number": preferences.getString("phone_number")
  };

  var userData = jsonEncode(_userData);

  return userData;
}
