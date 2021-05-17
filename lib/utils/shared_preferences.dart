import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<void> updateSharedPreferences(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  static Future<String> getSharedPreferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}
