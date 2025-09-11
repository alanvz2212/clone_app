import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/models/user.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _userTypeKey = 'user_type';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _stayLoggedInKey = 'stay_logged_in';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  Future<void> setToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  // User management
  Future<void> setUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
    await _prefs.setString(_userTypeKey, user.userType.name);
  }

  Future<User?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        // If parsing fails, clear the corrupted data
        await clearUser();
        return null;
      }
    }
    return null;
  }

  Future<UserType?> getUserType() async {
    final userTypeString = _prefs.getString(_userTypeKey);
    if (userTypeString != null) {
      return UserType.values.firstWhere(
        (type) => type.name == userTypeString,
        orElse: () => UserType.dealer,
      );
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_userTypeKey);
  }

  // App state management
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _prefs.setBool(_isFirstLaunchKey, isFirstLaunch);
  }

  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  // Persistent login management
  Future<void> setStayLoggedIn(bool stayLoggedIn) async {
    await _prefs.setBool(_stayLoggedInKey, stayLoggedIn);
  }

  Future<bool> getStayLoggedIn() async {
    return _prefs.getBool(_stayLoggedInKey) ?? true; // Default to true for better UX
  }

  Future<void> clearStayLoggedIn() async {
    await _prefs.remove(_stayLoggedInKey);
  }

  // Generic storage methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  Future<Set<String>> getKeys() async {
    return _prefs.getKeys();
  }
}
