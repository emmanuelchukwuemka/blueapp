import '../models/notification.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  /// Get all notifications
  Future<List<AppNotification>> getNotifications({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/notifications${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _apiService.get(endpoint);
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        final List<AppNotification> notifications = [];
        for (var notificationData in data['data']) {
          notifications.add(AppNotification.fromJson(notificationData));
        }
        return notifications;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch notifications');
      }
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _apiService.put('/notifications/$notificationId/read', {});
      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await _apiService.post('/notifications/mark-all-read', {});
      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to mark all notifications as read');
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await _apiService.delete('/notifications/$notificationId');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to delete notification');
      }
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiService.get('/notifications/unread-count');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return data['data']['count'] as int;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch unread notifications count');
      }
    } catch (e) {
      throw Exception('Failed to fetch unread notifications count: $e');
    }
  }
}