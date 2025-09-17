import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class CacheService {
  static const String _cachePrefix = 'api_cache_';
  static const Duration _defaultCacheDuration = Duration(minutes: 15);
  late final SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  Future<void> cacheResponse(
    String key,
    Map<String, dynamic> data, {
    Duration? duration,
  }) async {
    final cacheKey = _cachePrefix + key;
    final expirationTime = DateTime.now().add(
      duration ?? _defaultCacheDuration,
    );
    final cacheData = {
      'data': data,
      'expiration': expirationTime.millisecondsSinceEpoch,
    };
    await _prefs.setString(cacheKey, jsonEncode(cacheData));
  }
  Future<Map<String, dynamic>?> getCachedResponse(String key) async {
    final cacheKey = _cachePrefix + key;
    final cachedString = _prefs.getString(cacheKey);
    if (cachedString == null) return null;
    try {
      final cacheData = jsonDecode(cachedString) as Map<String, dynamic>;
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        cacheData['expiration'] as int,
      );
      if (DateTime.now().isAfter(expirationTime)) {
        await _prefs.remove(cacheKey);
        return null;
      }
      return cacheData['data'] as Map<String, dynamic>;
    } catch (e) {
      await _prefs.remove(cacheKey);
      return null;
    }
  }
  Future<void> clearCache(String key) async {
    final cacheKey = _cachePrefix + key;
    await _prefs.remove(cacheKey);
  }
  Future<void> clearAllCache() async {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith(_cachePrefix));
    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }
  Future<bool> isCacheValid(String key) async {
    final cachedData = await getCachedResponse(key);
    return cachedData != null;
  }
  Future<int> getCacheSize() async {
    final keys = _prefs.getKeys();
    return keys.where((key) => key.startsWith(_cachePrefix)).length;
  }
}

