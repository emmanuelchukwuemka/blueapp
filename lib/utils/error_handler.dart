import 'package:flutter/material.dart';

class ErrorHandler {
  /// Handle API errors
  static String handleApiError(dynamic error) {
    if (error is String) {
      return error;
    }
    
    if (error is Map<String, dynamic>) {
      if (error['message'] != null) {
        return error['message'];
      }
      
      if (error['error'] != null) {
        return error['error'];
      }
    }
    
    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle network errors
  static String handleNetworkError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network settings.';
    }
    
    if (error.toString().contains('TimeoutException')) {
      return 'Request timeout. Please try again.';
    }
    
    return 'Network error occurred. Please try again.';
  }

  /// Handle validation errors
  static String handleValidationError(String field, String error) {
    return '$field: $error';
  }

  /// Log error for debugging
  static void logError(String error, [StackTrace? stackTrace]) {
    print('Error: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  /// Show error to user
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  /// Show success message to user
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}