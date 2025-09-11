import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../core/di/injection.dart';

/// Helper class to test and demonstrate persistent login functionality
class AuthTestHelper {
  static final AuthService _authService = getIt<AuthService>();
  static final StorageService _storageService = getIt<StorageService>();

  /// Test the persistent login functionality
  static Future<void> testPersistentLogin() async {
    print('=== Testing Persistent Login Functionality ===');
    
    // Check current authentication status
    final isLoggedIn = await _authService.isLoggedIn();
    print('Current login status: $isLoggedIn');
    
    // Check if user wants to stay logged in
    final stayLoggedIn = await _authService.getStayLoggedIn();
    print('Stay logged in preference: $stayLoggedIn');
    
    // Check stored token
    final token = await _authService.getToken();
    print('Stored token exists: ${token != null && token.isNotEmpty}');
    
    // Check stored user
    final user = await _authService.getCurrentUser();
    print('Stored user exists: ${user != null}');
    print('User type: ${user?.userType}');
    print('User name: ${user?.name}');
    
    print('=== End Test ===');
  }

  /// Simulate logout and test that data is cleared
  static Future<void> testLogout() async {
    print('=== Testing Logout Functionality ===');
    
    print('Before logout:');
    await testPersistentLogin();
    
    // Perform logout
    await _authService.logout();
    print('Logout performed');
    
    print('After logout:');
    await testPersistentLogin();
    
    print('=== End Logout Test ===');
  }

  /// Manually set stay logged in preference
  static Future<void> setStayLoggedIn(bool value) async {
    await _authService.setStayLoggedIn(value);
    print('Stay logged in preference set to: $value');
  }

  /// Clear all authentication data (for testing)
  static Future<void> clearAllAuthData() async {
    await _storageService.clearToken();
    await _storageService.clearUser();
    await _storageService.clearStayLoggedIn();
    print('All authentication data cleared');
  }
}