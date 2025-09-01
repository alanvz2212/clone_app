class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://devapi.abm4trades.com';

  // Authentication Endpoints - Currently Used
  static const String customerLogin = '$baseUrl/auth/Login/CustomerLogin';
  static const String transporterLogin = '$baseUrl/auth/Login/TransporterLogin';
  static const String refreshToken = '$baseUrl/auth/Login/Refresh';

  // Search Endpoints
  static const String itemSearch = '$baseUrl/General/Item/Search';

  // Order Endpoints
  static const String customerOrders = '$baseUrl/api/MobileOrder/CustomerOrder';

  // Other endpoints (for future use)
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';
}
