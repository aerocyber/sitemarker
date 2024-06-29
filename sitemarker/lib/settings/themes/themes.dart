import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemesProvider extends ChangeNotifier {
  SharedPreferences? _pref;
  late bool _darkTheme;
  late bool _shadows;

  bool get darkTheme => _darkTheme;
  bool get shadows => _shadows;

  ThemesProvider() {
    _darkTheme = false;
    _shadows = false;
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

  switchShadows() {
    _shadows = !_shadows;
  }

  _initiateprefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadprefs() async {
    await _initiateprefs();
    _darkTheme = _pref?.getBool('theme') ?? false;
    _shadows = _pref?.getBool('shadows') ?? false;
    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    _pref?.setBool('theme', _darkTheme);
    _pref?.setBool('shadows', _shadows);
  }
}
