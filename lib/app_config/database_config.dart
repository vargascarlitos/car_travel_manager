export 'database/database_config.dart';
export 'database/database_helper.dart';
export 'database/database_migration.dart';
export 'database/database_tables.dart';

/// Configuración de base de datos para TaxiMeter Pro
/// 
/// Punto de entrada principal para toda la configuración de SQLite.
/// Exporta helper, migración, configuración y utilidades de base de datos.
/// 
/// Uso:
/// ```dart
/// import 'package:car_travel_manager/app_config/database_config.dart';
/// 
/// final db = DatabaseHelper();
/// await db.database; // Inicializar
/// ```



// Re-exportar SQLite para conveniencia
export 'package:sqflite/sqflite.dart' show
    Database,
    Transaction,
    Batch,
    ConflictAlgorithm;

// Re-exportar path para operaciones de archivo
export 'package:path/path.dart' show join;
