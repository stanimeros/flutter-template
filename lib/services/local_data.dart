import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  Future<dynamic> load(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.get(key);
    }
    return null; 
  }

  Future<void> save(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (data is List<String>) {
      await prefs.setStringList(key, data);
    } else if (data is int) {
      await prefs.setInt(key, data);
    } else if (data is bool) {
      await prefs.setBool(key, data);
    } else if (data is double) {
      await prefs.setDouble(key, data);
    } else if (data is String) {
      await prefs.setString(key, data);
    } else if (data is DateTime) {
      await prefs.setString(key, data.toUtc().toIso8601String());
    } else {
      throw ArgumentError('Unsupported data type');
    }
  }

  Future<bool> clearKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  Future<bool> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}