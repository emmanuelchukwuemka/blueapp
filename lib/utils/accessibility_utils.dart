import 'package:flutter/material.dart';

class AccessibilityUtils {
  /// Make text more accessible with proper semantics
  static Widget accessibleText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel ?? text,
      excludeSemantics: excludeFromSemantics,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }

  /// Create an accessible button with proper labeling
  static Widget accessibleButton({
    required VoidCallback onPressed,
    required Widget child,
    String? semanticsLabel,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: child,
        ),
      ),
    );
  }

  /// Create an accessible icon with proper labeling
  static Widget accessibleIcon({
    required IconData icon,
    required String label,
    double size = 24.0,
    Color? color,
    VoidCallback? onPressed,
  }) {
    return Semantics(
      label: label,
      button: onPressed != null,
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        onPressed: onPressed,
        tooltip: label,
      ),
    );
  }

  /// Create a high contrast theme for accessibility
  static ThemeData getHighContrastTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: brightness == Brightness.light
          ? const ColorScheme.highContrastLight()
          : const ColorScheme.highContrastDark(),
    );
  }

  /// Check if user prefers reduced motion
  static bool prefersReducedMotion(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.disableAnimations ||
        mediaQuery.platformBrightness == Brightness.dark;
  }

  /// Create a focusable widget for keyboard navigation
  static Widget focusableWidget({
    required Widget child,
    required VoidCallback onFocus,
    required VoidCallback onBlur,
    required VoidCallback onActivate,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          onFocus();
        } else {
          onBlur();
        }
      },
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space) {
          onActivate();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}