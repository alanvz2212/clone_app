import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cachePrefix = 'api_cache_';
  static const Duration _defaultCacheDuration = Duration(minutes: 15);

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Cache API response with expiration
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

  /// Get cached response if not expired
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
        // Cache expired, remove it
        await _prefs.remove(cacheKey);
        return null;
      }

      return cacheData['data'] as Map<String, dynamic>;
    } catch (e) {
      // Invalid cache data, remove it
      await _prefs.remove(cacheKey);
      return null;
    }
  }

  /// Clear specific cache entry
  Future<void> clearCache(String key) async {
    final cacheKey = _cachePrefix + key;
    await _prefs.remove(cacheKey);
  }

  /// Clear all cached responses
  Future<void> clearAllCache() async {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith(_cachePrefix));

    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }

  /// Check if cache exists and is valid
  Future<bool> isCacheValid(String key) async {
    final cachedData = await getCachedResponse(key);
    return cachedData != null;
  }

  /// Get cache size (number of cached entries)
  Future<int> getCacheSize() async {
    final keys = _prefs.getKeys();
    return keys.where((key) => key.startsWith(_cachePrefix)).length;
  }
}
