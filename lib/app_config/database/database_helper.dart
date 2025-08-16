import 'dart:io';
import 'package:car_travel_manager/app_config/utils/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_config.dart';
import 'database_tables.dart';
import 'database_migration.dart';

/// Helper principal para gestión de la base de datos SQLite de TaxiMeter Pro
/// 
/// Maneja la inicialización, migración y operaciones básicas de la base de datos.
/// Implementa patrón Singleton para garantizar una sola instancia de la DB.
class DatabaseHelper {
  // Singleton pattern
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // ========================================
  // GESTIÓN DE BASE DE DATOS
  // ========================================

  /// Obtener instancia de la base de datos
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializar base de datos
  Future<Database> _initDatabase() async {
    try {
      // Obtener directorio de la aplicación
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, DatabaseConfig.databaseName);

      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Inicializando base de datos en: $path');
      }

      // Abrir/crear base de datos
      return await openDatabase(
        path,
        version: DatabaseConfig.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
        onOpen: _onOpen,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      throw DatabaseException('Error al inicializar base de datos: $e');
    }
  }

  // ========================================
  // CALLBACKS DE BASE DE DATOS
  // ========================================

  /// Configuración inicial de la base de datos
  Future<void> _onConfigure(Database db) async {
    if (DatabaseConfig.enableSqlLogging) {
      MyLogger.log('${DatabaseConfig.logPrefix} Configurando base de datos...');
    }

    // Habilitar foreign keys
    await db.rawQuery('PRAGMA foreign_keys = ON');
    
    // Configurar timeout
    await db.rawQuery('PRAGMA busy_timeout = ${DatabaseConfig.operationTimeoutSeconds * 1000}');
    
    // Configurar WAL mode para mejor concurrencia
    await db.rawQuery('PRAGMA journal_mode = WAL');
    
    // Configurar synchronous mode para balance performance/seguridad
    await db.rawQuery('PRAGMA synchronous = NORMAL');
  }

  /// Creación inicial de la base de datos
  Future<void> _onCreate(Database db, int version) async {
    if (DatabaseConfig.enableSqlLogging) {
      MyLogger.log('${DatabaseConfig.logPrefix} Creando base de datos versión $version...');
    }

    try {
      // Crear todas las tablas
      for (String script in DatabaseTables.allCreateTableScripts) {
        await db.execute(script);
        if (DatabaseConfig.enableSqlLogging) {
          MyLogger.log('${DatabaseConfig.logPrefix} Tabla creada');
        }
      }

      // Crear todos los índices
      for (String script in DatabaseTables.allIndexScripts) {
        await db.execute(script);
        if (DatabaseConfig.enableSqlLogging) {
          MyLogger.log('${DatabaseConfig.logPrefix} Índice creado');
        }
      }

      // Crear todos los triggers
      for (String script in DatabaseTables.allTriggerScripts) {
        await db.execute(script);
        if (DatabaseConfig.enableSqlLogging) {
          MyLogger.log('${DatabaseConfig.logPrefix} Trigger creado');
        }
      }

      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Base de datos creada exitosamente');
      }
    } catch (e) {
      throw DatabaseException('Error al crear base de datos: $e');
    }
  }

  /// Migración de base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (DatabaseConfig.enableSqlLogging) {
      MyLogger.log('${DatabaseConfig.logPrefix} Migrando base de datos de v$oldVersion a v$newVersion...');
    }

    try {
      await DatabaseMigration.migrate(db, oldVersion, newVersion);
      
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Migración completada exitosamente');
      }
    } catch (e) {
      throw DatabaseException('Error al migrar base de datos: $e');
    }
  }

  /// Downgrade de base de datos (evitar si es posible)
  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    if (DatabaseConfig.enableSqlLogging) {
      MyLogger.log('${DatabaseConfig.logPrefix} ⚠️ Downgrade de v$oldVersion a v$newVersion');
    }
    
    // En producción, evitar downgrades
    throw DatabaseException('Downgrade no soportado de v$oldVersion a v$newVersion');
  }

  /// Callback cuando la base de datos se abre
  Future<void> _onOpen(Database db) async {
    if (DatabaseConfig.enableSqlLogging) {
      MyLogger.log('${DatabaseConfig.logPrefix} Base de datos abierta exitosamente');
    }

    // Verificar integridad
    await _verifyDatabaseIntegrity(db);
  }

  // ========================================
  // OPERACIONES BÁSICAS
  // ========================================

  /// Verificar integridad de la base de datos
  Future<void> _verifyDatabaseIntegrity(Database db) async {
    try {
      final result = await db.rawQuery('PRAGMA integrity_check;');
      final integrity = result.first['integrity_check'];
      
      if (integrity != 'ok') {
        throw DatabaseException('Integridad de base de datos comprometida: $integrity');
      }
      
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} ✅ Integridad verificada');
      }
    } catch (e) {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} ⚠️ Error verificando integridad: $e');
      }
    }
  }

  /// Cerrar base de datos
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Base de datos cerrada');
      }
    }
  }

  /// Eliminar base de datos (solo para testing)
  Future<void> deleteDatabase() async {
    try {
      await close();
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, DatabaseConfig.databaseName);
      
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        
        if (DatabaseConfig.enableSqlLogging) {
          MyLogger.log('${DatabaseConfig.logPrefix} Base de datos eliminada');
        }
      }
    } catch (e) {
      throw DatabaseException('Error al eliminar base de datos: $e');
    }
  }

  // ========================================
  // TRANSACCIONES
  // ========================================

  /// Ejecutar operación en transacción
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    
    try {
      return await db.transaction(action);
    } catch (e) {
      throw DatabaseException('Error en transacción: $e');
    }
  }

  /// Ejecutar operación en transacción con rollback manual
  Future<T> batch<T>(Future<T> Function(Batch batch) action) async {
    final db = await database;
    
    try {
      final batch = db.batch();
      final result = await action(batch);
      await batch.commit(noResult: true);
      return result;
    } catch (e) {
      throw DatabaseException('Error en operación batch: $e');
    }
  }

  // ========================================
  // UTILIDADES DE CONSULTA
  // ========================================

  /// Ejecutar consulta SELECT con logs opcionales
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    
    try {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Query: $table WHERE $where');
      }
      
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw DatabaseException('Error en consulta: $e');
    }
  }

  /// Ejecutar INSERT con validación
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    
    try {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Insert: $table');
      }
      
      return await db.insert(
        table, 
        values,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      throw DatabaseException('Error en inserción: $e');
    }
  }

  /// Ejecutar UPDATE con validación
  Future<int> update(
    String table, 
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    
    try {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Update: $table WHERE $where');
      }
      
      return await db.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw DatabaseException('Error en actualización: $e');
    }
  }

  /// Ejecutar DELETE con validación
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    
    try {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Delete: $table WHERE $where');
      }
      
      return await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw DatabaseException('Error en eliminación: $e');
    }
  }

  // ========================================
  // MANTENIMIENTO
  // ========================================

  /// Optimizar base de datos (VACUUM + ANALYZE)
  Future<void> optimize() async {
    final db = await database;
    
    try {
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} Optimizando base de datos...');
      }
      
      await db.execute('VACUUM;');
      await db.execute('ANALYZE;');
      
      if (DatabaseConfig.enableSqlLogging) {
        MyLogger.log('${DatabaseConfig.logPrefix} ✅ Optimización completada');
      }
    } catch (e) {
      throw DatabaseException('Error al optimizar base de datos: $e');
    }
  }

  /// Obtener información de la base de datos
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    
    try {
      final version = await db.getVersion();
      final path = db.path;
      
      // Obtener tamaño del archivo
      final file = File(path);
      final size = await file.length();
      
      // Obtener estadísticas de tablas
      final tablesInfo = await db.rawQuery('''
        SELECT name, 
               (SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%') as table_count
        FROM sqlite_master 
        WHERE type='table' AND name NOT LIKE 'sqlite_%'
      ''');
      
      return {
        'version': version,
        'path': path,
        'size_bytes': size,
        'size_mb': (size / (1024 * 1024)).toStringAsFixed(2),
        'tables': tablesInfo,
      };
    } catch (e) {
      throw DatabaseException('Error obteniendo información de DB: $e');
    }
  }
}

/// Excepción personalizada para errores de base de datos
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}
