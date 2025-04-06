//ignore: unused_import
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  // Set integer value
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences?.setInt(key, value);
  }

  // Get integer value
  int getInt(String key) {
    return _sharedPreferences?.getInt(key) ?? 0;
  }

  // Set String value
  Future<void> setString(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  // Get String value  
  String getString(String key) {
    return _sharedPreferences?.getString(key) ?? '';
  }

  // Set boolean value
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences?.setBool(key, value);
  }

  // Get boolean value
  bool getBool(String key) {
    return _sharedPreferences?.getBool(key) ?? false;
  }

  // Set double value
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences?.setDouble(key, value);
  }

  // Get double value
  double getDouble(String key) {
    return _sharedPreferences?.getDouble(key) ?? 0.0;
  }

  // Save object
  Future<void> setObject(String key, Object value) async {
    String jsonString = json.encode(value);
    await _sharedPreferences?.setString(key, jsonString);
  }

  // Get object
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? jsonString = _sharedPreferences?.getString(key);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return fromJson(jsonMap);
    }
    return null;
  }

  // Save list of objects
  Future<void> setObjectList<T>(String key, List<T> value) async {
    List<String> stringList = value.map((item) => json.encode(item)).toList();
    await _sharedPreferences?.setStringList(key, stringList);
  }

  // Get list of objects
  List<T> getObjectList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    List<String>? stringList = _sharedPreferences?.getStringList(key);
    if (stringList != null) {
      return stringList
          .map((item) => fromJson(json.decode(item)))
          .toList();
    }
    return [];
  }

  // Check if key exists
  bool containsKey(String key) {
    return _sharedPreferences?.containsKey(key) ?? false;
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    return await _sharedPreferences?.remove(key) ?? false;
  }
}
