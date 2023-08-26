import 'package:shared_preferences/shared_preferences.dart';

class Sf {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value); //Future.value(false);
  }

  static bool getBoolean(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue ?? false;
  }

  static Future<bool> setBoolean(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value); //?? Future.value(false);
  }

  static int getInt(String key, [int? defValue]) {
    return _prefsInstance?.getInt(key) ?? defValue ?? 0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value); //?? Future.value(false);
  }

  static Future removeAll() async {
    await _prefsInstance?.clear();
  }
}