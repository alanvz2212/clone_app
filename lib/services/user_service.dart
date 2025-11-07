import '../features/auth/models/user.dart';
import '../features/auth/dealer/models/dealer.dart';
import '../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../features/auth/dealer/bloc/dealer_auth_state.dart';
import 'auth_service.dart';
import 'storage_service.dart';
class UserService {
  final AuthService _authService;
  final DealerAuthBloc? _dealerAuthBloc;
  final StorageService _storageService;
  UserService(this._authService, this._storageService, [this._dealerAuthBloc]);
  Future<User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }
  Future<int?> getCurrentId() async {
    final user = await getCurrentUser();
    if (user != null && user.id != 0) {
      return user.id;
    }
    try {
      if (_dealerAuthBloc != null) {
        final state = _dealerAuthBloc!.state;
        if (state.isAuthenticated && state.dealer != null && state.dealer!.id != 0) {
          return state.dealer!.id;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  Future<int> getCurrentIdWithFallback([int fallback = 38590]) async {
    final id = await getCurrentId();
    if (id == null || id == 0) {
      return fallback;
    }
    return id;
  }
  Future<int?> getCurrentCustomerId() async {
    return await getCurrentId();
  }
  Future<int> getCurrentCustomerIdWithFallback([int fallback = 38590]) async {
    return await getCurrentIdWithFallback(fallback);
  }
  Future<bool> isUserLoggedIn() async {
    return await _authService.isLoggedIn();
  }
  Future<String?> getCurrentUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }
  Future<String?> getCurrentUserMobile() async {
    final user = await getCurrentUser();
    return user?.mobileNumber;
  }
  Future<String?> getCurrentUserEmail() async {
    final user = await getCurrentUser();
    return user?.email;
  }
  Future<UserType?> getCurrentUserType() async {
    final user = await getCurrentUser();
    return user?.userType;
  }
  Future<List<dynamic>> getMobileUser() async {
    return await _storageService.getMobileUser();
  }
  Future<String?> getPhoneNumber() async {
    return await _storageService.getPhoneNumber();
  }
  Future<void> setMobileUserAndPhoneNumber(List<dynamic> mobileUser, String phoneNumber) async {
    await _storageService.setMobileUser(mobileUser);
    await _storageService.setPhoneNumber(phoneNumber);
  }
}

