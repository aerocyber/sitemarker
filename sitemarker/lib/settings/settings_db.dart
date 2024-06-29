import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;

  SettingsProvider() {
    _loadprefs();
  }

  _initiateprefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadprefs() async {
    await _initiateprefs();
    // _darkTheme = _pref?.getBool(key) ?? false;
    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    // _pref?.setBool(key, _darkTheme);
  }
}
