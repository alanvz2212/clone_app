import 'package:hive/hive.dart';
import '../models/dealer.dart';
import '../models/dealer_hive.dart';
import '../models/auth_data_hive.dart';
class DealerAuthHiveService {
  static const String _authBoxName = 'dealer_auth_box';
  static const String _authDataKey = 'auth_data';
  static Box<AuthDataHive>? _authBox;
  static Future<void> init() async {
    _authBox = await Hive.openBox<AuthDataHive>(_authBoxName);
  }
  static Box<AuthDataHive> get authBox {
    if (_authBox == null || !_authBox!.isOpen) {
      throw Exception(
        'Auth box is not initialized. Call DealerAuthHiveService.init() first.',
      );
    }
    return _authBox!;
  }
  static Future<void> saveAuthData({
    required String token,
    required Dealer dealer,
    String? mobileNumber,
    String? password,
    bool stayLoggedIn = false,
  }) async {
    final dealerHive = DealerHive.fromDealer(dealer);
    final authData = AuthDataHive(
      token: token,
      dealer: dealerHive,
      isAuthenticated: true,
      loginTime: DateTime.now(),
      stayLoggedIn: stayLoggedIn,
      mobileNumber: mobileNumber,
      password: password,
    );
    await authBox.put(_authDataKey, authData);
    print('=== Auth data saved to Hive ===');
    print('Token: ${token.substring(0, 20)}...');
    print('Dealer: ${dealer.name}');
    print('Customer ID: ${dealer.id}');
    print('Stay logged in: $stayLoggedIn');
  }
  static AuthDataHive? getAuthData() {
    final authData = authBox.get(_authDataKey);
    if (authData != null) {
      print('=== Auth data retrieved from Hive ===');
      print('Is authenticated: ${authData.isAuthenticated}');
      print('Dealer: ${authData.dealer?.name}');
      print('Token exists: ${authData.token != null}');
      print('Stay logged in: ${authData.stayLoggedIn}');
    } else {
      print('=== No auth data found in Hive ===');
    }
    return authData;
  }
  static Dealer? getCurrentDealer() {
    final authData = getAuthData();
    return authData?.dealer?.toDealer();
  }
  static String? getCurrentToken() {
    final authData = getAuthData();
    return authData?.token;
  }
  static bool isAuthenticated() {
    final authData = getAuthData();
    return authData?.isAuthenticated ?? false;
  }
  static bool shouldStayLoggedIn() {
    final authData = getAuthData();
    return authData?.stayLoggedIn ?? false;
  }
  static Map<String, String?> getSavedCredentials() {
    final authData = getAuthData();
    return {
      'mobileNumber': authData?.mobileNumber,
      'password': authData?.password,
    };
  }
  static Future<void> updateToken(String newToken) async {
    final currentAuthData = getAuthData();
    if (currentAuthData != null) {
      final updatedAuthData = currentAuthData.copyWith(token: newToken);
      await authBox.put(_authDataKey, updatedAuthData);
      print('=== Token updated in Hive ===');
    }
  }
  static Future<void> updateStayLoggedIn(bool stayLoggedIn) async {
    final currentAuthData = getAuthData();
    if (currentAuthData != null) {
      final updatedAuthData = currentAuthData.copyWith(stayLoggedIn: stayLoggedIn);
      await authBox.put(_authDataKey, updatedAuthData);
      print('=== Stay logged in preference updated: $stayLoggedIn ===');
    }
  }
  static Future<void> clearAuthData() async {
    await authBox.delete(_authDataKey);
    print('=== Auth data cleared from Hive (logout) ===');
  }
  static Future<void> close() async {
    if (_authBox != null && _authBox!.isOpen) {
      await _authBox!.close();
      _authBox = null;
    }
  }
  static bool hasAuthData() {
    return authBox.containsKey(_authDataKey);
  }
  static DateTime? getLoginTime() {
    final authData = getAuthData();
    return authData?.loginTime;
  }
  static bool isSessionExpired({Duration sessionDuration = const Duration(days: 30)}) {
    final loginTime = getLoginTime();
    if (loginTime == null) return true;
    final now = DateTime.now();
    final difference = now.difference(loginTime);
    return difference > sessionDuration;
  }
  static Future<void> refreshSession() async {
    final currentAuthData = getAuthData();
    if (currentAuthData != null) {
      final updatedAuthData = currentAuthData.copyWith(loginTime: DateTime.now());
      await authBox.put(_authDataKey, updatedAuthData);
      print('=== Session refreshed in Hive ===');
    }
  }
}

