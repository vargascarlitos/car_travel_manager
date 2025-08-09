import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_config/theme_config.dart';
import 'app_config/router_config.dart';
import 'app_config/database/database_helper.dart';
import 'domain/repositories/trip_repository.dart';
import 'data/repositories/trip_repository_impl.dart';

/// Punto de entrada principal de TaxiMeter Pro
/// 
/// Aplicación de taxímetro con arquitectura Clean y BLoC.
/// Implementa Material Design 3 con Bolt Dark Theme.
void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar la UI del sistema (barra de estado, etc.)
  AppTheme.setSystemUIOverlayStyle();
  
  // Ejecutar la aplicación
  runApp(const TaxiMeterApp());
}

/// Widget raíz de la aplicación TaxiMeter Pro
class TaxiMeterApp extends StatelessWidget {
  const TaxiMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TripRepository>(
      create: (_) => TripRepositoryImpl(DatabaseHelper()),
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
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.systemUiOverlayStyle,
            child: child!,
          );
        },
      ),
    );
  }
}