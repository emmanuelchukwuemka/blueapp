import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _authToken;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get authToken => _authToken;
  String? get error => _error;

  final AuthService _authService = AuthService();

  // Check if user is logged in
  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(AppConstants.authTokenKey);
      _isAuthenticated = _authToken != null;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String emailOrPhone, String password, bool rememberMe) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(emailOrPhone, password);
      _authToken = result['token'];
      _isAuthenticated = true;

      // Save token and remember me preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.authTokenKey, _authToken!);
      await prefs.setBool(AppConstants.rememberMeKey, rememberMe);
      await prefs.setBool(AppConstants.isLoggedInKey, true);

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

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String accountType,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        accountType: accountType,
      );
      
      // Registration successful, user needs to verify OTP
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

  // Verify OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.verifyOtp(phone, otp);
      _authToken = result['token'];
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.authTokenKey, _authToken!);
      await prefs.setBool(AppConstants.isLoggedInKey, true);

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

  // Resend OTP
  Future<bool> resendOtp(String phone) async {
    try {
      await _authService.resendOtp(phone);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Forgot Password
  Future<bool> forgotPassword(String emailOrPhone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(emailOrPhone);
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

  // Reset Password
  Future<bool> resetPassword(String otp, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(otp, newPassword);
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

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _authToken = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
