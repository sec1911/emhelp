// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';

String _key = "";

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _key = preferences.getString("key");

  return _key;
}
