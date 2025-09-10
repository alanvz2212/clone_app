import 'package:get_it/get_it.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/storage_service.dart';
import '../../services/cache_service.dart';
import '../../services/network_service.dart';
import '../../features/auth/dealer/repositories/dealer_auth_repository.dart';
import '../../features/auth/transporter/repositories/transporter_auth_repository.dart';
import '../../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../features/auth/transporter/bloc/transporter_auth_bloc.dart';
import '../../features/Dashboard/Dealer/Cards/Place_Order/repositories/search_item_repository.dart';
import '../../features/Dashboard/Dealer/Cards/Place_Order/bloc/search_item_bloc.dart';
import '../../constants/api_endpoints.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core Services
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  final cacheService = CacheService();
  await cacheService.init();
  getIt.registerSingleton<CacheService>(cacheService);

  final networkService = NetworkService();
  networkService.initialize();
  getIt.registerSingleton<NetworkService>(networkService);

  // API Service with dependencies - create as singleton so it's available immediately
  final apiService = ApiService(getIt<CacheService>(), getIt<NetworkService>());
  getIt.registerSingleton<ApiService>(apiService);

  // Create AuthService and initialize it
  final authService = AuthService(apiService, getIt<StorageService>());
  await authService.initializeAuth();
  getIt.registerSingleton<AuthService>(authService);

  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt<AuthService>()),
  );

  // Repositories
  getIt.registerLazySingleton<DealerAuthRepository>(
    () => DealerAuthRepository(baseUrl: ApiEndpoints.baseUrl),
  );

  getIt.registerLazySingleton<TransporterAuthRepository>(
    () => TransporterAuthRepository(baseUrl: ApiEndpoints.baseUrl),
  );

  getIt.registerLazySingleton<SearchItemRepository>(
    () => SearchItemRepository(),
  );

  // BLoCs
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
}

// Helper methods for easy access
ApiService get apiService => getIt<ApiService>();
AuthService get authService => getIt<AuthService>();
UserService get userService => getIt<UserService>();
StorageService get storageService => getIt<StorageService>();
DealerAuthRepository get dealerAuthRepository => getIt<DealerAuthRepository>();
TransporterAuthRepository get transporterAuthRepository =>
    getIt<TransporterAuthRepository>();
