import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final SharedPreferences _prefs = SharedPreferences.getInstance() as SharedPreferences;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // SharedPreferences methods
  Future<bool> saveString(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    final prefs = await _prefs;
    return prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<bool> saveDouble(String key, double value) async {
    final prefs = await _prefs;
    return prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    return prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return prefs.remove(key);
  }

  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }

  // Secure storage methods
  Future<void> saveSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // JSON serialization helpers
  Future<bool> saveObject<T>(String key, T object, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = jsonEncode(object);
    return saveString(key, jsonString);
  }

  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
}