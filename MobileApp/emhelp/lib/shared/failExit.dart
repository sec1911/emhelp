// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';

failExit() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
}
