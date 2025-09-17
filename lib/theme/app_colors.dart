import 'package:flutter/material.dart';
class AppColors {
  AppColors._();
  static const Color primary = Color(0xFFCEB007);
  static const Color primaryLight = Color(0xFFCEB007);
  static const Color primaryDark = Color(0xFFCEB007);
  static const Color primarySwatch = Colors.orange;
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSurface = Color(0xFF424242);
  static const Color success = Colors.black;
  static const Color successLight = Colors.black;
  static const Color successDark = Colors.black;
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color info = Color(0xFFCEB007);
  static const Color infoLight = Color(0xFFCEB007);
  static const Color infoDark = Color(0xFFCEB007);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
  static const Color disabled = Color(0xFF9E9E9E);
  static const Color shadow = Color(0x1F000000);
  static const Color networkConnected = success;
  static const Color networkDisconnected = error;
  static const Color networkUnknown = warning;
  static const Color badgeBackground = error;
  static const Color badgeText = textOnPrimary;
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = surface;
  static const Color buttonDisabled = disabled;
  static const Color inputBackground = surface;
  static const Color inputBorder = border;
  static const Color inputFocused = primary;
  static const Color inputError = error;
  static const Color tabSelected = textOnPrimary;
  static const Color tabUnselected = textSecondary;
  static const Color tabIndicator = primary;
  static const Color appBarBackground = primary;
  static const Color appBarForeground = textOnPrimary;
  static const Color scaffoldBackground = background;
  static const List<Color> primaryGradient = [primary, primaryDark];
  static const List<Color> successGradient = [success, successDark];
  static const List<Color> errorGradient = [error, errorDark];
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
  static const MaterialColor primaryMaterialColor = Colors.orange;
}

