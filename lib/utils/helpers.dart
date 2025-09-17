import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Helpers {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red.shade600);
  }
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.black);
  }
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Color(0xFFCEB007));
  }
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        );
      },
    );
  }
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
  static String formatMobileNumber(String mobile) {
    final digitsOnly = mobile.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }
    return mobile;
  }
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }
  static bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.shortestSide >= 600;
  }
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  static void vibrate() {
    HapticFeedback.lightImpact();
  }
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  static String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  static bool isValidMobile(String mobile) {
    final digitsOnly = mobile.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          (chars.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)
              .floor(),
        ),
      ),
    );
  }
  static Timer? _debounceTimer;
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
}

