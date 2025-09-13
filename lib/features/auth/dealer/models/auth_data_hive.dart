import 'package:hive/hive.dart';
import 'dealer_hive.dart';

part 'auth_data_hive.g.dart';

@HiveType(typeId: 2) // Unique typeId for AuthData model
class AuthDataHive {
  @HiveField(0)
  final String? token;

  @HiveField(1)
  final DealerHive? dealer;

  @HiveField(2)
  final bool isAuthenticated;

  @HiveField(3)
  final DateTime? loginTime;

  @HiveField(4)
  final bool stayLoggedIn;

  @HiveField(5)
  final String? mobileNumber;

  @HiveField(6)
  final String? password;

  AuthDataHive({
    this.token,
    this.dealer,
    this.isAuthenticated = false,
    this.loginTime,
    this.stayLoggedIn = false,
    this.mobileNumber,
    this.password,
  });

  AuthDataHive copyWith({
    String? token,
    DealerHive? dealer,
    bool? isAuthenticated,
    DateTime? loginTime,
    bool? stayLoggedIn,
    String? mobileNumber,
    String? password,
  }) {
    return AuthDataHive(
      token: token ?? this.token,
      dealer: dealer ?? this.dealer,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loginTime: loginTime ?? this.loginTime,
      stayLoggedIn: stayLoggedIn ?? this.stayLoggedIn,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
    );
  }

  // Create empty/logout state
  static AuthDataHive empty() {
    return AuthDataHive(
      token: null,
      dealer: null,
      isAuthenticated: false,
      loginTime: null,
      stayLoggedIn: false,
      mobileNumber: null,
      password: null,
    );
  }
}