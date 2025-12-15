import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get list of enrolled biometric types
  static Future<List<BiometricType>> getEnrolledBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting enrolled biometrics: $e');
      return [];
    }
  }

  /// Authenticate with biometrics
  static Future<bool> authenticate({String localizedReason = 'Authenticate to access your account'}) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        androidAuthStrings: const AndroidAuthMessages(
          signInTitle: 'Biometric Authentication',
          cancelButton: 'Cancel',
          goToSettingsButton: 'Settings',
          goToSettingsDescription: 'Please enable biometric authentication in settings',
        ),
        iOSAuthStrings: const IOSAuthMessages(
          cancelButton: 'Cancel',
          goToSettingsButton: 'Settings',
          goToSettingsDescription: 'Please enable biometric authentication in settings',
        ),
      );
      
      return didAuthenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  /// Check if biometric auth is enabled for the user
  static Future<bool> isBiometricAuthEnabled() async {
    // This would typically check local storage or user preferences
    // For now, we'll return false as a placeholder
    return false;
  }

  /// Enable biometric authentication for the user
  static Future<void> enableBiometricAuth() async {
    // This would typically save the preference to local storage
    // For now, we'll just print a message
    print('Biometric authentication enabled');
  }

  /// Disable biometric authentication for the user
  static Future<void> disableBiometricAuth() async {
    // This would typically remove the preference from local storage
    // For now, we'll just print a message
    print('Biometric authentication disabled');
  }
}