import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemesProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemesProvider() {
    _darkTheme = false;
    _loadprefs();
  }

  switchThemeLight() {
    _darkTheme = false;
    _saveprefs();
    notifyListeners();
  }

  switchThemeDark() {
    _darkTheme = true;
    _saveprefs();
    notifyListeners();
  }

  _initiateprefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadprefs() async {
    await _initiateprefs();
    _darkTheme = _pref?.getBool(key) ?? false;
    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    _pref?.setBool(key, _darkTheme);
  }
}
