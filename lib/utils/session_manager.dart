import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  Timer? _sessionTimer;
  int _sessionTimeoutMinutes = AppConstants.sessionTimeout;

  /// Initialize session management
  void initializeSessionManagement() {
    _startSessionTimer();
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        final prefs = await SharedPreferences.getInstance();
        final lastActive = prefs.getInt('last_active_time') ?? DateTime.now().millisecondsSinceEpoch;
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final elapsedMinutes = (currentTime - lastActive) / 60000;

        if (elapsedMinutes > _sessionTimeoutMinutes) {
          // Session expired, logout user
          _handleSessionExpiry();
        }
      },
    );
  }

  /// Update last active time
  Future<void> updateLastActiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_active_time', DateTime.now().millisecondsSinceEpoch);
  }

  /// Handle session expiry
  void _handleSessionExpiry() async {
    _sessionTimer?.cancel();
    
    // Clear session data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    // TODO: Navigate to login screen
    // This would typically involve calling a callback or using a navigator key
  }

  /// Extend session timeout
  void extendSessionTimeout(int minutes) {
    _sessionTimeoutMinutes = minutes;
  }

  /// Manually expire session
  Future<void> expireSession() async {
    _sessionTimer?.cancel();
    _handleSessionExpiry();
  }

  /// Dispose session manager
  void dispose() {
    _sessionTimer?.cancel();
  }
}