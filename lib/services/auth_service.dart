import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// Login user with email/phone and password
  Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email_or_phone': emailOrPhone,
        'password': password,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'token': data['data']['token'],
          'user': User.fromJson(data['data']['user']),
        };
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String accountType,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'account_type': accountType,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'message': data['message'],
          'user': User.fromJson(data['data']['user']),
        };
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Verify OTP code
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _apiService.post('/auth/verify-otp', {
        'phone': phone,
        'otp': otp,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'token': data['data']['token'],
          'user': User.fromJson(data['data']['user']),
        };
      } else {
        throw Exception(data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  /// Resend OTP code
  Future<void> resendOtp(String phone) async {
    try {
      final response = await _apiService.post('/auth/resend-otp', {
        'phone': phone,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      throw Exception('Failed to resend OTP: $e');
    }
  }

  /// Request password reset
  Future<void> forgotPassword(String emailOrPhone) async {
    try {
      final response = await _apiService.post('/auth/forgot-password', {
        'email_or_phone': emailOrPhone,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to send password reset link');
      }
    } catch (e) {
      throw Exception('Failed to send password reset link: $e');
    }
  }

  /// Reset password with OTP and new password
  Future<void> resetPassword(String otp, String newPassword) async {
    try {
      final response = await _apiService.post('/auth/reset-password', {
        'otp': otp,
        'new_password': newPassword,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return User.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}