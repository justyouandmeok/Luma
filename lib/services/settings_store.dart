import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const _kApi = 'yt_api_key';
  static const _kFavs = 'fav_tracks';

  Future<String> apiKey() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kApi) ?? 'AIzaSyDoRRon52y_JtgbpKIrCRNLQtQwVRSj81c';
  }

  Future<void> setApiKey(String key) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kApi, key.trim());
  }

  Future<List<String>> favJson() async {
    final p = await SharedPreferences.getInstance();
    return p.getStringList(_kFavs) ?? [];
  }

  Future<void> setFavJson(List<String> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_kFavs, items);
  }
}
