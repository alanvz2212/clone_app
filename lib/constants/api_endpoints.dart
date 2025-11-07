class ApiEndpoints {
  static const String baseUrl = 'https://tmsapi.abm4trades.com';

  // Auth
  static const String customerLogin = '$baseUrl/auth/Login/CustomerLogin';
  static const String transporterLogin = '$baseUrl/auth/Login/TransporterLogin';
  static const String refreshToken = '$baseUrl/auth/Login/Refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';

  // OTP
  static String sendOtp(String phoneNumber) =>
      '$baseUrl/auth/Login/send-otp?phoneNumber=$phoneNumber';
  static String verifyOtp(String phoneNumber, String otp) =>
      '$baseUrl/auth/Login/verify-otp?phoneNumber=$phoneNumber&otp=$otp';

  // General
  static const String itemSearch = '$baseUrl/General/Item/MobileSearch';
  static String itemSearchWithQuery(String query) =>
      '$baseUrl/General/Item/MobileSearch?query=$query';
  static const String feedbackEndpoint = '$baseUrl/General/FeedBack';
  static const String contactUsEndpoint =
      '$baseUrl/General/Register'; //contactus

  // Order
  static const String customerOrders = '$baseUrl/api/MobileOrder/CustomerOrder';
  static const String newMobileOrder =
      '$baseUrl/api/MobileOrder/NewMobileOrder';

  // Sales
  static String customerSalesWithId(int customerId) =>
      '$baseUrl/Inventory/Sales/GetCustomerSales?customerId=$customerId';

  // Sales Order
  static String customerSalesOrderWithId(int customerId) =>
      '$baseUrl/Inventory/SalesOrder/GetCustomerSalesOrder?customerId=$customerId';

  // Stock
  static String itemStockWithId(String itemId) =>
      '$baseUrl/api/Stock/ItemStock?itemId=$itemId';

  //Gallery
  static const String gallery = '$baseUrl/api/GalleryType/GetAll';
  static String galleryDocuments(int id) =>
      '$baseUrl/api/Gallery/GetByType/$id';

  //specifier
  static const String specifiercreateEndpoint = '$baseUrl/api/Specification';

  //mobilelog
  static const String mobilelogs = '$baseUrl/General/MobileLog/NewMobileLogs';

  //Scheme dealer
  static String schemeDealerWithId(int userId) =>
      '$baseUrl/General/Scheme/GetCustomerScheme?userId=$userId';

  // //Scheme specifier
  static String schemeSpecifierWithId(int userId) =>
      '$baseUrl/General/Scheme/GetSpecifierScheme?userId=$userId';
}
