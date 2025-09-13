import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/Services/cart_hive_service.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/models/cart_item_hive.dart';
import 'package:clone/features/auth/dealer/models/dealer_hive.dart';
import 'package:clone/features/auth/dealer/models/auth_data_hive.dart';
import 'package:clone/features/auth/dealer/services/dealer_auth_hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/dealer/bloc/dealer_auth_bloc.dart';
import 'features/auth/dealer/bloc/dealer_auth_event.dart';
import 'features/auth/transporter/bloc/transporter_auth_bloc.dart';
import 'features/Dashboard/Dealer/Cards/Place_Order/bloc/search_item_bloc.dart';
import 'features/Dashboard/Dealer/Cards/Place_Order/providers/cart_provider.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(CartItemHiveAdapter());
  Hive.registerAdapter(DealerHiveAdapter());
  Hive.registerAdapter(AuthDataHiveAdapter());

  // Initialize services
  await CartHiveService.init();
  await DealerAuthHiveService.init();

  // Setup dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DealerAuthBloc>(
            create: (context) => getIt<DealerAuthBloc>()..add(DealerAuthRestoreRequested()),
          ),
          BlocProvider<TransporterAuthBloc>(
            create: (context) => getIt<TransporterAuthBloc>(),
          ),
          BlocProvider<SearchItemBloc>(
            create: (context) => getIt<SearchItemBloc>(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'clone',
          theme: AppTheme.lightTheme.copyWith(
            extensions: [
              NetworkStatusTheme.light,
              QuickAccessTileTheme.light,
              DashboardTheme.light,
            ],
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
