import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/user_service.dart';
import '../config/constants.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final UserService _userService = UserService();

  // Load user data from local storage
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userDataKey);
      
      if (userData != null) {
        _user = User.fromJson(json.decode(userData));
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  // Fetch user from API
  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // MOCK DATA for development
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
      
      _user = User(
        id: 'user_123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        accountType: 'user',
        totalPoints: 12500,
        joinDate: DateTime.now().subtract(const Duration(days: 30)),
        profilePicture: null,
      );
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userDataKey,
        json.encode(_user!.toJson()),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        profilePicture: profilePicture,
      );
      
      _user = updatedUser;
      
      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userDataKey,
        json.encode(_user!.toJson()),
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update points (called after successful redemption or earning)
  void updatePoints(int newPoints) {
    if (_user != null) {
      _user = _user!.copyWith(totalPoints: newPoints);
      notifyListeners();
    }
  }

  // Clear user data
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
