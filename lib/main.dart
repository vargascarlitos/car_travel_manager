import 'package:car_travel_manager/app_config/database/database_demo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'app_config/theme_config.dart';
import 'app_config/router_config.dart';
import 'app_config/database/database_helper.dart';
import 'domain/repositories/trip_repository.dart';
import 'data/repositories/trip_repository_impl.dart';
import 'domain/repositories/review_repository.dart';
import 'data/repositories/review_repository_impl.dart';

/// Punto de entrada principal de TaxiMeter Pro
///
/// Aplicación de taxímetro con arquitectura Clean y BLoC.
/// Implementa Material Design 3 con Bolt Dark Theme.
Future<void> main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar la UI del sistema (barra de estado, etc.)
  AppTheme.setSystemUIOverlayStyle();
  if (kDebugMode) {
    await DatabaseDemo.seedHistoryTrips(days: 7, perDay: 6);
  }

  // Ejecutar la aplicación
  runApp(const TaxiMeterApp());
}

/// Widget raíz de la aplicación TaxiMeter Pro
class TaxiMeterApp extends StatelessWidget {
  const TaxiMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TripRepository>(create: (_) => TripRepositoryImpl(DatabaseHelper())),
        RepositoryProvider<ReviewRepository>(create: (_) => ReviewRepositoryImpl(DatabaseHelper())),
      ],
      child: MaterialApp(
        // Información de la aplicación
        title: 'TaxiMeter Pro',

        // Configuración de debug
        debugShowCheckedModeBanner: false,

        // Tema principal - Solo Dark Theme (Bolt)
        theme: AppTheme.darkTheme,

        // No hay tema claro - solo dark según requerimientos
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Configuración de rutas
        initialRoute: AppRouter.initialRoute,
        onGenerateRoute: AppRouter.generateRoute,

        // Configuración de Material Design
        builder:
            (context, child) => ResponsiveBreakpoints.builder(
              child: Builder(
                builder: (context) {
                  return ResponsiveScaledBox(
                    width:
                        ResponsiveValue<double?>(
                          context,
                          conditionalValues: [
                            const Condition.equals(name: MOBILE, value: 450),
                            const Condition.between(
                              start: 800,
                              end: 1100,
                              value: 800,
                            ),
                            const Condition.between(
                              start: 1000,
                              end: 1200,
                              value: 700,
                            ),
                          ],
                        ).value,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        boldText: false,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: AppTheme.systemUiOverlayStyle,
                        child: child!,
                      ),
                    ),
                  );
                },
              ),
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
      ),
    );
  }
}
