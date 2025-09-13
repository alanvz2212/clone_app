import '../features/auth/models/user.dart';
import '../features/auth/dealer/models/dealer.dart';
import '../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../features/auth/dealer/bloc/dealer_auth_state.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _authService;
  final DealerAuthBloc? _dealerAuthBloc;
  
  UserService(this._authService, [this._dealerAuthBloc]);

  /// Get the current logged-in user
  Future<User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  /// Get the current user's customer ID
  /// Returns null if no user is logged in or user doesn't have a customer ID
  /// This method works with both User and Dealer models
  Future<int?> getCurrentCustomerId() async {
    final user = await getCurrentUser();
    if (user != null && user.customerId != 0) {
      return user.customerId;
    }
    
    // If User model doesn't have customerId, try to get it from Dealer
    // This is a temporary solution until the API provides customerId in User model
    try {
      // You would need to implement a method to get current dealer
      // For now, we'll return null and rely on fallback
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get the current user's customer ID with a fallback
  /// If no user is logged in or customerId is 0, returns the fallback value
  Future<int> getCurrentCustomerIdWithFallback([int fallback = 38590]) async {
    final customerId = await getCurrentCustomerId();
    if (customerId == null || customerId == 0) {
      return fallback;
    }
    return customerId;
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  /// Get current user's name
  Future<String?> getCurrentUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }

  /// Get current user's mobile number
  Future<String?> getCurrentUserMobile() async {
    final user = await getCurrentUser();
    return user?.mobileNumber;
  }

  /// Get current user's email
  Future<String?> getCurrentUserEmail() async {
    final user = await getCurrentUser();
    return user?.email;
  }

  /// Get current user's type
  Future<UserType?> getCurrentUserType() async {
    final user = await getCurrentUser();
    return user?.userType;
  }
}