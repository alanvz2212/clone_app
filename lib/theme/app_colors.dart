import 'package:flutter/material.dart';

/// App Color Palette
/// Centralized color definitions for consistent theming across the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1976D2); // Blue shade 700
  static const Color primaryLight = Color(0xFF42A5F5); // Blue shade 400
  static const Color primaryDark = Color(0xFF0D47A1); // Blue shade 900
  static const Color primarySwatch = Colors.blue;

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF5F5F5); // Grey shade 100
  static const Color surfaceLight = Color(0xFFFAFAFA); // Grey shade 50

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Black 87%
  static const Color textSecondary = Color(0xFF757575); // Grey shade 600
  static const Color textTertiary = Color(0xFF9E9E9E); // Grey shade 400
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textOnSurface = Color(0xFF424242); // Grey shade 800

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green shade 600
  static const Color successLight = Color(0xFF81C784); // Green shade 300
  static const Color successDark = Color(0xFF2E7D32); // Green shade 800

  static const Color error = Color(0xFFE53935); // Red shade 600
  static const Color errorLight = Color(0xFFEF5350); // Red shade 400
  static const Color errorDark = Color(0xFFC62828); // Red shade 800

  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFB74D); // Orange shade 300
  static const Color warningDark = Color(0xFFF57C00); // Orange shade 700

  static const Color info = Color(0xFF2196F3); // Blue shade 600
  static const Color infoLight = Color(0xFF64B5F6); // Blue shade 300
  static const Color infoDark = Color(0xFF1565C0); // Blue shade 800

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0); // Grey shade 300
  static const Color border = Color(0xFFBDBDBD); // Grey shade 400
  static const Color disabled = Color(0xFF9E9E9E); // Grey shade 400
  static const Color shadow = Color(0x1F000000); // Black with 12% opacity

  // Network Status Colors
  static const Color networkConnected = success;
  static const Color networkDisconnected = error;
  static const Color networkUnknown = warning;

  // Badge Colors
  static const Color badgeBackground = error;
  static const Color badgeText = textOnPrimary;

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = surface;
  static const Color buttonDisabled = disabled;

  // Input Field Colors
  static const Color inputBackground = surface;
  static const Color inputBorder = border;
  static const Color inputFocused = primary;
  static const Color inputError = error;

  // Tab Colors
  static const Color tabSelected = textOnPrimary;
  static const Color tabUnselected = textSecondary;
  static const Color tabIndicator = primary;

  // Specific App Colors
  static const Color appBarBackground = primary;
  static const Color appBarForeground = textOnPrimary;
  static const Color scaffoldBackground = background;

  // Gradient Colors
  static const List<Color> primaryGradient = [primary, primaryDark];

  static const List<Color> successGradient = [success, successDark];

  static const List<Color> errorGradient = [error, errorDark];

  // Opacity Variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color successWithOpacity(double opacity) =>
      success.withValues(alpha: opacity);
  static Color errorWithOpacity(double opacity) =>
      error.withValues(alpha: opacity);
  static Color warningWithOpacity(double opacity) =>
      warning.withValues(alpha: opacity);
  static Color greyWithOpacity(double opacity) =>
      Colors.grey.withValues(alpha: opacity);

  // Material Color Swatches for ThemeData
  static const MaterialColor primaryMaterialColor = Colors.blue;
}
