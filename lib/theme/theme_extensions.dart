import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Custom Theme Extensions
/// Additional theme properties not covered by standard Flutter themes

/// Network Status Theme Extension
@immutable
class NetworkStatusTheme extends ThemeExtension<NetworkStatusTheme> {
  const NetworkStatusTheme({
    required this.connectedColor,
    required this.disconnectedColor,
    required this.unknownColor,
    required this.textColor,
  });

  final Color connectedColor;
  final Color disconnectedColor;
  final Color unknownColor;
  final Color textColor;

  static const NetworkStatusTheme light = NetworkStatusTheme(
    connectedColor: AppColors.networkConnected,
    disconnectedColor: AppColors.networkDisconnected,
    unknownColor: AppColors.networkUnknown,
    textColor: AppColors.textOnPrimary,
  );

  @override
  NetworkStatusTheme copyWith({
    Color? connectedColor,
    Color? disconnectedColor,
    Color? unknownColor,
    Color? textColor,
  }) {
    return NetworkStatusTheme(
      connectedColor: connectedColor ?? this.connectedColor,
      disconnectedColor: disconnectedColor ?? this.disconnectedColor,
      unknownColor: unknownColor ?? this.unknownColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  NetworkStatusTheme lerp(NetworkStatusTheme? other, double t) {
    if (other is! NetworkStatusTheme) {
      return this;
    }
    return NetworkStatusTheme(
      connectedColor: Color.lerp(connectedColor, other.connectedColor, t)!,
      disconnectedColor: Color.lerp(
        disconnectedColor,
        other.disconnectedColor,
        t,
      )!,
      unknownColor: Color.lerp(unknownColor, other.unknownColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }
}

/// Quick Access Tile Theme Extension
@immutable
class QuickAccessTileTheme extends ThemeExtension<QuickAccessTileTheme> {
  const QuickAccessTileTheme({
    required this.backgroundColor,
    required this.iconColor,
    required this.titleColor,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  final Color backgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color badgeColor;
  final Color badgeTextColor;

  static const QuickAccessTileTheme light = QuickAccessTileTheme(
    backgroundColor: AppColors.surface,
    iconColor: AppColors.primary,
    titleColor: AppColors.textPrimary,
    badgeColor: AppColors.badgeBackground,
    badgeTextColor: AppColors.badgeText,
  );

  @override
  QuickAccessTileTheme copyWith({
    Color? backgroundColor,
    Color? iconColor,
    Color? titleColor,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return QuickAccessTileTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      titleColor: titleColor ?? this.titleColor,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
    );
  }

  @override
  QuickAccessTileTheme lerp(QuickAccessTileTheme? other, double t) {
    if (other is! QuickAccessTileTheme) {
      return this;
    }
    return QuickAccessTileTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t)!,
      badgeTextColor: Color.lerp(badgeTextColor, other.badgeTextColor, t)!,
    );
  }
}

/// Dashboard Theme Extension
@immutable
class DashboardTheme extends ThemeExtension<DashboardTheme> {
  const DashboardTheme({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.welcomeTextColor,
    required this.userNameTextColor,
    required this.notificationIconColor,
  });

  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color welcomeTextColor;
  final Color userNameTextColor;
  final Color notificationIconColor;

  static const DashboardTheme light = DashboardTheme(
    headerBackgroundColor: AppColors.primary,
    headerTextColor: AppColors.textOnPrimary,
    welcomeTextColor: Color(0x70FFFFFF), // White with 70% opacity
    userNameTextColor: AppColors.textOnPrimary,
    notificationIconColor: AppColors.textOnPrimary,
  );

  @override
  DashboardTheme copyWith({
    Color? headerBackgroundColor,
    Color? headerTextColor,
    Color? welcomeTextColor,
    Color? userNameTextColor,
    Color? notificationIconColor,
  }) {
    return DashboardTheme(
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      welcomeTextColor: welcomeTextColor ?? this.welcomeTextColor,
      userNameTextColor: userNameTextColor ?? this.userNameTextColor,
      notificationIconColor:
          notificationIconColor ?? this.notificationIconColor,
    );
  }

  @override
  DashboardTheme lerp(DashboardTheme? other, double t) {
    if (other is! DashboardTheme) {
      return this;
    }
    return DashboardTheme(
      headerBackgroundColor: Color.lerp(
        headerBackgroundColor,
        other.headerBackgroundColor,
        t,
      )!,
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t)!,
      welcomeTextColor: Color.lerp(
        welcomeTextColor,
        other.welcomeTextColor,
        t,
      )!,
      userNameTextColor: Color.lerp(
        userNameTextColor,
        other.userNameTextColor,
        t,
      )!,
      notificationIconColor: Color.lerp(
        notificationIconColor,
        other.notificationIconColor,
        t,
      )!,
    );
  }
}

/// Helper extension to access custom themes from BuildContext
extension ThemeExtensions on BuildContext {
  NetworkStatusTheme get networkStatusTheme =>
      Theme.of(this).extension<NetworkStatusTheme>() ??
      NetworkStatusTheme.light;

  QuickAccessTileTheme get quickAccessTileTheme =>
      Theme.of(this).extension<QuickAccessTileTheme>() ??
      QuickAccessTileTheme.light;

  DashboardTheme get dashboardTheme =>
      Theme.of(this).extension<DashboardTheme>() ?? DashboardTheme.light;
}
