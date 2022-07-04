import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  SharedPreferences? prefs;
  bool darkMode = true;

  Settings() {
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    darkMode = prefs?.getBool("darkMode") ?? true;
    prefs?.setBool('darkMode', darkMode);
    notifyListeners();
  }

  void changeTheme() async {
    darkMode = !(prefs?.getBool("darkMode") ?? true);
    prefs?.setBool('darkMode', darkMode);
    notifyListeners();
  }
}
