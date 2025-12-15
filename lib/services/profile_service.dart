import '../models/user.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  /// Get user profile
  Future<User> getProfile() async {
    try {
      final response = await _apiService.get('/profile');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return User.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
  }) async {
    try {
      final response = await _apiService.put('/profile', {
        'name': name,
        'email': email,
        'phone': phone,
        'profile_picture': profilePicture,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return User.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post('/profile/change-password', {
        'current_password': currentPassword,
        'new_password': newPassword,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    bool? emailNotifications,
    bool? pushNotifications,
  }) async {
    try {
      final response = await _apiService.put('/profile/notification-preferences', {
        'email_notifications': emailNotifications,
        'push_notifications': pushNotifications,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to update notification preferences');
      }
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _apiService.get('/profile/stats');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch user statistics');
      }
    } catch (e) {
      throw Exception('Failed to fetch user statistics: $e');
    }
  }
}