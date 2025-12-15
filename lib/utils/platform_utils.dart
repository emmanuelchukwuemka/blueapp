import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformUtils {
  /// Check if running on Android
  static bool isAndroid() {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Check if running on iOS
  static bool isIOS() {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Check if running on web
  static bool isWeb() {
    return kIsWeb;
  }

  /// Get platform-specific padding
  static double getPlatformPadding() {
    if (isIOS()) {
      return 20.0; // iOS typically needs more padding for safe areas
    }
    return 16.0; // Default padding
  }

  /// Get platform-specific button style
  static bool shouldUseMaterialStyle() {
    return isAndroid() || isWeb();
  }

  /// Get platform-specific animation duration
  static Duration getAnimationDuration() {
    if (isIOS()) {
      return const Duration(milliseconds: 300); // iOS typically uses slower animations
    }
    return const Duration(milliseconds: 200); // Android uses faster animations
  }

  /// Check if device has notch/cutout
  static bool hasNotch() {
    // This is a simplified check. In a real app, you might use a package like `flutter_statusbar_size`
    return isIOS(); // Simplified assumption
  }
}