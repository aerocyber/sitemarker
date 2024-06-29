import 'package:shared_preferences/shared_preferences.dart';

// TODO: Implement logging
class SettingsPref {
  final SharedPreferences prefInstance;
  late bool autoUpdate;
  late String themeName;
  SettingsPref({required this.prefInstance}) {
    themeName = prefInstance.getString('theme') ?? 'default';
    autoUpdate = prefInstance.getBool('autoUpdate') ?? false;
  }

  void setTheme(String themeName) {
    this.themeName = themeName;
    prefInstance.setString('theme', themeName);
  }

  void setAutoUpdate(bool autoUpdate) {
    this.autoUpdate = autoUpdate;
    prefInstance.setBool('autoUpdate', autoUpdate);
  }

  bool getAutoUpdate() {
    return autoUpdate;
  }

  String getTheme() {
    return themeName;
  }
}
