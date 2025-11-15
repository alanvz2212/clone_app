import 'package:abm4customerapp/features/Dashboard/Dealer/Cards/Place_Order/Services/cart_hive_service.dart';
import 'package:abm4customerapp/features/Dashboard/Dealer/Cards/Place_Order/models/cart_item_hive.dart';
import 'package:abm4customerapp/features/auth/dealer/models/dealer_hive.dart';
import 'package:abm4customerapp/features/auth/dealer/models/auth_data_hive.dart';
import 'package:abm4customerapp/features/auth/dealer/services/dealer_auth_hive_service.dart';
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
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("WorkManager background task executed: $task");
    if (task == "simplePeriodicTask") {
      print("Running periodic task...");
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemHiveAdapter());
  Hive.registerAdapter(DealerHiveAdapter());
  Hive.registerAdapter(AuthDataHiveAdapter());
  await CartHiveService.init();
  await DealerAuthHiveService.init();
  await setupDependencyInjection();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "uniqueName", 
    "simplePeriodicTask", 
    frequency: Duration(minutes: 15), 
  );
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
            create: (context) =>
                getIt<DealerAuthBloc>()..add(DealerAuthRestoreRequested()),
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
          title: 'abm4customerapp',
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
