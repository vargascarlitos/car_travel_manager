/// Configuración principal de TaxiMeter Pro
/// 
/// Punto de entrada unificado para toda la configuración de la aplicación:
/// - Tema y Material Design 3
/// - Base de datos SQLite 
/// - Router y navegación
/// 
/// Uso:
/// ```dart
/// import 'package:car_travel_manager/app_config/app_config.dart';
/// 
/// // Acceso a configuraciones:
/// AppTheme.darkTheme
/// DatabaseHelper()
/// AppRouter.generateRoute
/// ```

// ========================================
// CONFIGURACIÓN DE TEMA
// ========================================
export 'theme_config.dart';

// ========================================
// CONFIGURACIÓN DE BASE DE DATOS
// ========================================
export 'database_config.dart';

// ========================================
// CONFIGURACIÓN DE ROUTER
// ========================================
export 'router_config.dart';
