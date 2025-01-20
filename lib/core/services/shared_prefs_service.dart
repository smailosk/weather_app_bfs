import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_bfs/core/models/weather_model.dart';

class SharedPrefsService {
  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<void> clearAll() async {
    await _preferences?.clear();
  }
}
