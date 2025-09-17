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
          _currentToken = loginResponse.token!;
          _currentUser = loginResponse.user;
          await _storageService.setToken(loginResponse.token!);
          if (loginResponse.user != null) {
            await _storageService.setUser(loginResponse.user!);
          }
          await _storageService.setStayLoggedIn(true);
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
      await _apiService.post(ApiEndpoints.logout);
    } catch (e) {
    } finally {
      _currentToken = null;
      _currentUser = null;
      await _storageService.clearToken();
      await _storageService.clearUser();
      await _storageService.clearStayLoggedIn();
      await _storageService.clearAllCredentials();
      _apiService.removeAuthToken();
    }
  }
  Future<bool> isLoggedIn() async {
    final stayLoggedIn = await _storageService.getStayLoggedIn();
    if (!stayLoggedIn) {
      return false;
    }
    if (_currentToken != null && _currentToken!.isNotEmpty) {
      return true;
    }
    final storedToken = await _storageService.getToken();
    return storedToken != null && storedToken.isNotEmpty;
  }
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    _currentUser = await _storageService.getUser();
    return _currentUser;
  }
  Future<String?> getToken() async {
    if (_currentToken != null) {
      return _currentToken;
    }
    _currentToken = await _storageService.getToken();
    return _currentToken;
  }
  Future<bool> refreshToken() async {
    try {
      final currentToken = await getToken();
      if (currentToken == null) return false;
      _apiService.setAuthToken(currentToken);
      final response = await _apiService.getFullUrl(ApiEndpoints.refreshToken);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final newToken = responseData['token'] as String?;
        final userData = responseData['user'] as Map<String, dynamic>?;
        if (newToken != null) {
          _currentToken = newToken;
          _apiService.setAuthToken(newToken);
          await _storageService.setToken(newToken);
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
      await logout();
      return false;
    }
  }
  Future<bool> shouldRefreshToken() async {
    final token = await getToken();
    if (token == null) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      return true;
    } catch (e) {
      return true;
    }
  }
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
      useHardcodedToken();
    }
  }
  void useHardcodedToken() {
    _apiService.setAuthToken(token);
  }
  String getHardcodedToken() {
    return token;
  }
  String getSasToken() {
    return sasToken;
  }
  bool isUsingHardcodedToken() {
    return _currentToken == null && token.isNotEmpty;
  }
  Future<void> setToken(String token) async {
    _currentToken = token;
    await _storageService.setToken(token);
    _apiService.setAuthToken(token);
  }
  
  Future<void> setUser(User user) async {
    _currentUser = user;
    await _storageService.setUser(user);
  }
  Future<void> setStayLoggedIn(bool stayLoggedIn) async {
    await _storageService.setStayLoggedIn(stayLoggedIn);
  }
  Future<bool> getStayLoggedIn() async {
    return await _storageService.getStayLoggedIn();
  }
}

