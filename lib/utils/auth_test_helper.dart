import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../core/di/injection.dart';
class AuthTestHelper {
  static final AuthService _authService = getIt<AuthService>();
  static final StorageService _storageService = getIt<StorageService>();
  static Future<void> testPersistentLogin() async {
    print('=== Testing Persistent Login Functionality ===');
    final isLoggedIn = await _authService.isLoggedIn();
    print('Current login status: $isLoggedIn');
    final stayLoggedIn = await _authService.getStayLoggedIn();
    print('Stay logged in preference: $stayLoggedIn');
    final token = await _authService.getToken();
    print('Stored token exists: ${token != null && token.isNotEmpty}');
    final user = await _authService.getCurrentUser();
    print('Stored user exists: ${user != null}');
    print('User type: ${user?.userType}');
    print('User name: ${user?.name}');
    print('=== End Test ===');
  }
  static Future<void> testLogout() async {
    print('=== Testing Logout Functionality ===');
    print('Before logout:');
    await testPersistentLogin();
    await _authService.logout();
    print('Logout performed');
    print('After logout:');
    await testPersistentLogin();
    print('=== End Logout Test ===');
  }
  static Future<void> setStayLoggedIn(bool value) async {
    await _authService.setStayLoggedIn(value);
    print('Stay logged in preference set to: $value');
  }
  static Future<void> clearAllAuthData() async {
    await _storageService.clearToken();
    await _storageService.clearUser();
    await _storageService.clearStayLoggedIn();
    print('All authentication data cleared');
  }
}

