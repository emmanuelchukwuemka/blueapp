import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  static const String _tasksCacheKey = 'cached_tasks';
  static const String _transactionsCacheKey = 'cached_transactions';
  static const String _profileCacheKey = 'cached_profile';
  static const String _notificationsCacheKey = 'cached_notifications';

  /// Cache tasks data
  Future<void> cacheTasks(List<dynamic> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks);
    await prefs.setString(_tasksCacheKey, jsonString);
  }

  /// Get cached tasks data
  Future<List<dynamic>?> getCachedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_tasksCacheKey);
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return List<dynamic>.from(decoded);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Cache transactions data
  Future<void> cacheTransactions(List<dynamic> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(transactions);
    await prefs.setString(_transactionsCacheKey, jsonString);
  }

  /// Get cached transactions data
  Future<List<dynamic>?> getCachedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_transactionsCacheKey);
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return List<dynamic>.from(decoded);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Cache profile data
  Future<void> cacheProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile);
    await prefs.setString(_profileCacheKey, jsonString);
  }

  /// Get cached profile data
  Future<Map<String, dynamic>?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileCacheKey);
    if (jsonString != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Cache notifications data
  Future<void> cacheNotifications(List<dynamic> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(notifications);
    await prefs.setString(_notificationsCacheKey, jsonString);
  }

  /// Get cached notifications data
  Future<List<dynamic>?> getCachedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notificationsCacheKey);
    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);
        return List<dynamic>.from(decoded);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksCacheKey);
    await prefs.remove(_transactionsCacheKey);
    await prefs.remove(_profileCacheKey);
    await prefs.remove(_notificationsCacheKey);
  }
}