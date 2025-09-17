class ApiEndpoints {
  static const String baseUrl = 'https://tmsapi.abm4trades.com';//tmsapi.abm4trades.com';
  static const String customerLogin = '$baseUrl/auth/Login/CustomerLogin';
  static const String transporterLogin = '$baseUrl/auth/Login/TransporterLogin';
  static const String refreshToken = '$baseUrl/auth/Login/Refresh';
  static const String itemSearch = '$baseUrl/General/Item/MobileSearch';
  static const String customerOrders = '$baseUrl/api/MobileOrder/CustomerOrder';
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';
}

