import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmSettings {
  String? smServerUrl;
  String? smUsername;
  String? smPassword;
  String? versionSaved;

  SmSettings({
    this.smServerUrl,
    this.smUsername,
    this.smPassword,
    this.versionSaved,
  });

  Future<SmSettings> loadFromStore(SharedPreferencesAsync settingsStore) async {
    smServerUrl = await settingsStore.getString('SM_SERVER_URL');
    smUsername = await settingsStore.getString('SM_USERNAME');
    smPassword = await settingsStore.getString('SM_PASSWORD');
    versionSaved = await settingsStore.getString('VERSION_SAVED');
    return this;
  }

  bool shouldShowWelcome() {
    return versionSaved == null;
  }

  bool isLoggedIn() {
    return smServerUrl != null && smUsername != null && smPassword != null;
  }

  login(SharedPreferencesAsync settingsStore, String username, String password,
      String serverUrl) async {
    await settingsStore.setString('SM_SERVER_URL', serverUrl);
    await settingsStore.setString('SM_USERNAME', username);
    await settingsStore.setString('SM_PASSWORD', password);
    smServerUrl = serverUrl;
    smUsername = username;
    smPassword = password;
  }

  logout(SharedPreferencesAsync settingsStore) async {
    await settingsStore.remove('SM_SERVER_URL');
    await settingsStore.remove('SM_USERNAME');
    await settingsStore.remove('SM_PASSWORD');
    smServerUrl = null;
    smUsername = null;
    smPassword = null;
  }

  Future<bool> shouldShowChangeLog(
      SharedPreferencesAsync settingsStore) async {
    String? currentVersion = (await PackageInfo.fromPlatform()).version;
    if (currentVersion != versionSaved) {
      versionSaved = currentVersion;
      await settingsStore.setString('VERSION_SAVED', versionSaved!);
      return true;
    }
    return false;
  }
}
