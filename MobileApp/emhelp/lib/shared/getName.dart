// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';

String _nameString = "";

Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _nameString = preferences.getString("first_name");

  return _nameString;
}
