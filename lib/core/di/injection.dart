import 'package:get_it/get_it.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/storage_service.dart';
import '../../services/cache_service.dart';
import '../../services/network_service.dart';
import '../../services/mobile_log_service.dart';
import '../../features/auth/dealer/repositories/dealer_auth_repository.dart';
import '../../features/auth/transporter/repositories/transporter_auth_repository.dart';
import '../../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../features/auth/transporter/bloc/transporter_auth_bloc.dart';
import '../../features/Dashboard/Dealer/Cards/Place_Order/repositories/search_item_repository.dart';
import '../../features/Dashboard/Dealer/Cards/Place_Order/bloc/search_item_bloc.dart';
import '../../features/OTP_authentication/Sent_otp/services/otp_service.dart';
import '../../features/OTP_authentication/Sent_otp/bloc/otp_bloc.dart';
import '../../features/OTP_authentication/verify_otp/services/verify_otp_service.dart';
import '../../features/OTP_authentication/verify_otp/bloc/verify_otp_bloc.dart';
import '../../features/Dashboard/Dealer/Cards/Gallery_Type/service/gallery_type_service.dart';
import '../../features/Dashboard/Dealer/Cards/Gallery_Type/bloc/gallery_type_bloc.dart';
import '../../features/Dashboard/Dealer/Cards/Gallery/services/gallery_service.dart';
import '../../features/Dashboard/Dealer/Cards/Gallery/bloc/gallery_bloc.dart';
import '../../constants/api_endpoints.dart';
final GetIt getIt = GetIt.instance;
Future<void> setupDependencyInjection() async {
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);
  final cacheService = CacheService();
  await cacheService.init();
  getIt.registerSingleton<CacheService>(cacheService);
  final networkService = NetworkService();
  networkService.initialize();
  getIt.registerSingleton<NetworkService>(networkService);
  final apiService = ApiService(getIt<CacheService>(), getIt<NetworkService>());
  getIt.registerSingleton<ApiService>(apiService);
  final authService = AuthService(apiService, getIt<StorageService>());
  await authService.initializeAuth();
  getIt.registerSingleton<AuthService>(authService);
  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt<AuthService>()),
  );
  getIt.registerLazySingleton<DealerAuthRepository>(
    () => DealerAuthRepository(baseUrl: ApiEndpoints.baseUrl),
  );
  getIt.registerLazySingleton<TransporterAuthRepository>(
    () => TransporterAuthRepository(baseUrl: ApiEndpoints.baseUrl),
  );
  getIt.registerLazySingleton<SearchItemRepository>(
    () => SearchItemRepository(),
  );
  getIt.registerLazySingleton<OtpService>(
    () => OtpService(),
  );
  getIt.registerLazySingleton<VerifyOtpService>(
    () => VerifyOtpService(),
  );

  getIt.registerLazySingleton<MobileLogService>(
    () => MobileLogService(),
  );

  getIt.registerLazySingleton<GalleryService>(
    () => GalleryService(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<GalleryDocumentService>(
    () => GalleryDocumentService(getIt<ApiService>()),
  );
  getIt.registerFactory<DealerAuthBloc>(
    () => DealerAuthBloc(
      repository: getIt<DealerAuthRepository>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerFactory<TransporterAuthBloc>(
    () => TransporterAuthBloc(
      repository: getIt<TransporterAuthRepository>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerFactory<SearchItemBloc>(
    () => SearchItemBloc(repository: getIt<SearchItemRepository>()),
  );
  getIt.registerFactory<OtpBloc>(
    () => OtpBloc(otpService: getIt<OtpService>()),
  );
  getIt.registerFactory<VerifyOtpBloc>(
    () => VerifyOtpBloc(
      verifyOtpService: getIt<VerifyOtpService>(),
      authService: getIt<AuthService>(),
      mobileLogService: getIt<MobileLogService>(),
    ),
  );

  getIt.registerFactory<GalleryBloc>(
    () => GalleryBloc(galleryService: getIt<GalleryService>()),
  );

  getIt.registerFactory<GalleryDocumentBloc>(
    () => GalleryDocumentBloc(galleryDocumentService: getIt<GalleryDocumentService>()),
  );
}
ApiService get apiService => getIt<ApiService>();
AuthService get authService => getIt<AuthService>();
UserService get userService => getIt<UserService>();
StorageService get storageService => getIt<StorageService>();
DealerAuthRepository get dealerAuthRepository => getIt<DealerAuthRepository>();
TransporterAuthRepository get transporterAuthRepository =>
    getIt<TransporterAuthRepository>();

