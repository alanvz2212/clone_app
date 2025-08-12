import '../features/auth/models/auth_model.dart';
import '../features/auth/models/user.dart';
import '../constants/api_endpoints.dart';
import '../constants/string_constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;
  String? _currentToken;
  User? _currentUser;

  AuthService(this._apiService, this._storageService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      // Determine the correct endpoint based on user type
      String endpoint;
      if (request.userType == UserType.dealer) {
        endpoint = ApiEndpoints.customerLogin;
      } else if (request.userType == UserType.transporter) {
        endpoint = ApiEndpoints.transporterLogin;
      } else {
        return LoginResponse.failure(error: 'Invalid user type');
      }

      final response = await _apiService.postCustomerLogin(
        endpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.success && loginResponse.token != null) {
          // Store token and user data in memory and persistent storage
          _currentToken = loginResponse.token!;
          _currentUser = loginResponse.user;

          // Persist to storage
          await _storageService.setToken(loginResponse.token!);
          if (loginResponse.user != null) {
            await _storageService.setUser(loginResponse.user!);
          }

          // Set auth token for future requests
          _apiService.setAuthToken(loginResponse.token!);
        }

        return loginResponse;
      } else {
        return LoginResponse.failure(
          error: 'Login failed with status: ${response.statusCode}',
        );
      }
    } on ApiException catch (e) {
      return LoginResponse.failure(error: e.message);
    } catch (e) {
      return LoginResponse.failure(error: 'An unexpected error occurred');
    }
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Call logout API if needed
      await _apiService.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local memory
      _currentToken = null;
      _currentUser = null;

      // Clear persistent storage
      await _storageService.clearToken();
      await _storageService.clearUser();

      // Remove auth token from API service
      _apiService.removeAuthToken();
    }
  }

  Future<bool> isLoggedIn() async {
    // Check memory first, then storage
    if (_currentToken != null && _currentToken!.isNotEmpty) {
      return true;
    }

    // Check persistent storage
    final storedToken = await _storageService.getToken();
    return storedToken != null && storedToken.isNotEmpty;
  }

  Future<User?> getCurrentUser() async {
    // Return from memory if available
    if (_currentUser != null) {
      return _currentUser;
    }

    // Load from storage if not in memory
    _currentUser = await _storageService.getUser();
    return _currentUser;
  }

  Future<String?> getToken() async {
    // Return from memory if available
    if (_currentToken != null) {
      return _currentToken;
    }

    // Load from storage if not in memory
    _currentToken = await _storageService.getToken();
    return _currentToken;
  }

  Future<bool> refreshToken() async {
    try {
      final currentToken = await getToken();
      if (currentToken == null) return false;

      // Set the current token for the refresh request
      _apiService.setAuthToken(currentToken);

      // Use GET request for refresh token endpoint with full URL
      final response = await _apiService.getFullUrl(ApiEndpoints.refreshToken);

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final newToken = responseData['token'] as String?;
        final userData = responseData['user'] as Map<String, dynamic>?;

        if (newToken != null) {
          _currentToken = newToken;
          _apiService.setAuthToken(newToken);

          // Persist new token
          await _storageService.setToken(newToken);

          // Update user data if provided
          if (userData != null) {
            final user = User.fromJson(userData);
            _currentUser = user;
            await _storageService.setUser(user);
          }

          return true;
        }
      }
      return false;
    } catch (e) {
      // If refresh fails, clear tokens to force re-login
      await logout();
      return false;
    }
  }

  /// Check if token needs refresh (call this periodically)
  Future<bool> shouldRefreshToken() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      // Decode JWT token to check expiration (simplified version)
      // In a real app, you'd use a JWT library to properly decode and validate
      final parts = token.split('.');
      if (parts.length != 3) return true; // Invalid token format

      // For now, we'll refresh every 30 minutes as a safety measure
      // You can implement proper JWT expiration checking here
      return true;
    } catch (e) {
      return true; // If we can't parse, better to refresh
    }
  }

  /// Auto-refresh token if needed
  Future<void> autoRefreshToken() async {
    if (await shouldRefreshToken()) {
      await refreshToken();
    }
  }

  Future<void> initializeAuth() async {
    final token = await getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    } else {
      // Use hardcoded token as fallback if no user token exists
      useHardcodedToken();
    }
  }

  /// Use the hardcoded token from string_constants.dart
  void useHardcodedToken() {
    _apiService.setAuthToken(token);
  }

  /// Get the hardcoded token
  String getHardcodedToken() {
    return token;
  }

  /// Get the SAS token for Azure Storage
  String getSasToken() {
    return sasToken;
  }

  /// Check if currently using hardcoded token
  bool isUsingHardcodedToken() {
    return _currentToken == null && token.isNotEmpty;
  }
}
