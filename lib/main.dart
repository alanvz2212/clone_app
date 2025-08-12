import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/dealer/bloc/dealer_auth_bloc.dart';
import 'features/auth/transporter/bloc/transporter_auth_bloc.dart';
import 'features/Dashboard/Dealer/Cards/Place_Order/bloc/search_item_bloc.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DealerAuthBloc>(
          create: (context) => getIt<DealerAuthBloc>(),
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
    );
  }
}
