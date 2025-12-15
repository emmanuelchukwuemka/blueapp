import 'package:flutter/material.dart';

class NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(String routeName, {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName, 
      predicate ?? (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  static Future<T?> push<T extends Object?>(Widget widget) {
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}