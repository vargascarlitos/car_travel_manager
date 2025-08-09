import 'package:sqflite/sqflite.dart';
import 'database_config.dart';
import 'database_tables.dart';

/// Gestor de migraciones de base de datos para TaxiMeter Pro
/// 
/// Maneja todas las migraciones entre versiones de la base de datos
/// de forma segura y con rollback en caso de errores.
class DatabaseMigration {
  DatabaseMigration._();

  // ========================================
  // MIGRACIÓN PRINCIPAL
  // ========================================

  /// Ejecutar migración de una versión a otra
  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    if (DatabaseConfig.enableSqlLogging) {
      print('${DatabaseConfig.logPrefix} Iniciando migración v$oldVersion → v$newVersion');
    }

    try {
      // Validar parámetros
      if (oldVersion >= newVersion) {
        throw MigrationException(
          'Versión de origen ($oldVersion) debe ser menor que destino ($newVersion)'
        );
      }

      // Crear punto de salvaguarda antes de migrar
      await _createSavepoint(db, 'migration_start');

      // Ejecutar migraciones secuenciales
      for (int version = oldVersion + 1; version <= newVersion; version++) {
        await _migrateToVersion(db, version);
        
        if (DatabaseConfig.enableSqlLogging) {
          print('${DatabaseConfig.logPrefix} ✅ Migrado a versión $version');
        }
      }

      // Liberar punto de salvaguarda si todo salió bien
      await _releaseSavepoint(db, 'migration_start');

      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ✅ Migración completada exitosamente');
      }
    } catch (e) {
      // Rollback en caso de error
      try {
        await _rollbackToSavepoint(db, 'migration_start');
        if (DatabaseConfig.enableSqlLogging) {
          print('${DatabaseConfig.logPrefix} ⚠️ Rollback realizado por error en migración');
        }
      } catch (rollbackError) {
        if (DatabaseConfig.enableSqlLogging) {
          print('${DatabaseConfig.logPrefix} ❌ Error en rollback: $rollbackError');
        }
      }
      
      throw MigrationException('Error en migración v$oldVersion → v$newVersion: $e');
    }
  }

  // ========================================
  // MIGRACIONES POR VERSIÓN
  // ========================================

  /// Migrar a una versión específica
  static Future<void> _migrateToVersion(Database db, int version) async {
    switch (version) {
      case 2:
        await _migrateToV2(db);
        break;
      case 3:
        await _migrateToV3(db);
        break;
      // Agregar futuras versiones aquí
      default:
        throw MigrationException('Migración a versión $version no implementada');
    }
  }

  // ========================================
  // MIGRACIÓN V1 → V2 (Backend Sync)
  // ========================================

  /// Migración a versión 2: Optimizaciones para sincronización con backend
  static Future<void> _migrateToV2(Database db) async {
    if (DatabaseConfig.enableSqlLogging) {
      print('${DatabaseConfig.logPrefix} Ejecutando migración v1 → v2 (Backend Sync)...');
    }

    try {
      // Los campos de sincronización ya están en v1, solo agregar índices optimizados
      for (String script in DatabaseTables.migrationV2Scripts) {
        await db.execute(script);
      }

      // Crear tabla de metadata de sincronización
      await db.execute(DatabaseTables.createSyncMetadataTable);

      // Insertar registro inicial de sync metadata
      await db.insert(DatabaseConfig.syncMetadataTable, {
        DatabaseConfig.fieldId: 'main_sync',
        'last_full_sync': DatabaseConfig.formatTimestamp(DateTime.now()),
        'last_incremental_sync': DatabaseConfig.formatTimestamp(DateTime.now()),
        'pending_uploads': 0,
        'sync_version': 1,
        DatabaseConfig.fieldCreatedAt: DatabaseConfig.formatTimestamp(DateTime.now()),
        DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(DateTime.now()),
      });

      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ✅ Migración v2 completada');
      }
    } catch (e) {
      throw MigrationException('Error en migración v2: $e');
    }
  }

  // ========================================
  // MIGRACIÓN V2 → V3 (Futura)
  // ========================================

  /// Migración a versión 3: Ejemplo para futuras mejoras
  static Future<void> _migrateToV3(Database db) async {
    if (DatabaseConfig.enableSqlLogging) {
      print('${DatabaseConfig.logPrefix} Ejecutando migración v2 → v3...');
    }

    try {
      // Ejemplo: Agregar nueva columna a trips
      await db.execute('''
        ALTER TABLE ${DatabaseConfig.tripsTable} 
        ADD COLUMN distance_km REAL DEFAULT 0.0 CHECK (distance_km >= 0.0);
      ''');

      // Ejemplo: Crear nuevo índice para la columna
      await db.execute('''
        CREATE INDEX idx_trips_distance 
        ON ${DatabaseConfig.tripsTable} (distance_km);
      ''');

      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ✅ Migración v3 completada');
      }
    } catch (e) {
      throw MigrationException('Error en migración v3: $e');
    }
  }

  // ========================================
  // UTILIDADES DE MIGRACIÓN
  // ========================================

  /// Crear punto de salvaguarda para rollback
  static Future<void> _createSavepoint(Database db, String name) async {
    try {
      await db.execute('SAVEPOINT $name;');
      
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} Savepoint "$name" creado');
      }
    } catch (e) {
      throw MigrationException('Error creando savepoint $name: $e');
    }
  }

  /// Liberar punto de salvaguarda
  static Future<void> _releaseSavepoint(Database db, String name) async {
    try {
      await db.execute('RELEASE SAVEPOINT $name;');
      
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} Savepoint "$name" liberado');
      }
    } catch (e) {
      // No es crítico si falla la liberación
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ⚠️ Error liberando savepoint $name: $e');
      }
    }
  }

  /// Rollback a punto de salvaguarda
  static Future<void> _rollbackToSavepoint(Database db, String name) async {
    try {
      await db.execute('ROLLBACK TO SAVEPOINT $name;');
      
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} Rollback a savepoint "$name" ejecutado');
      }
    } catch (e) {
      throw MigrationException('Error en rollback a savepoint $name: $e');
    }
  }

  // ========================================
  // VERIFICACIÓN DE MIGRACIÓN
  // ========================================

  /// Verificar que la migración se ejecutó correctamente
  static Future<bool> verifyMigration(Database db, int targetVersion) async {
    try {
      final version = await db.getVersion();
      
      if (version != targetVersion) {
        if (DatabaseConfig.enableSqlLogging) {
          print('${DatabaseConfig.logPrefix} ❌ Versión esperada: $targetVersion, actual: $version');
        }
        return false;
      }

      // Verificar integridad después de migración
      final result = await db.rawQuery('PRAGMA integrity_check;');
      final integrity = result.first['integrity_check'];
      
      if (integrity != 'ok') {
        if (DatabaseConfig.enableSqlLogging) {
          print('${DatabaseConfig.logPrefix} ❌ Integridad comprometida después de migración: $integrity');
        }
        return false;
      }

      // Verificar que las tablas existen
      if (targetVersion >= 1) {
        final tables = await db.rawQuery('''
          SELECT name FROM sqlite_master 
          WHERE type='table' 
          AND name IN ('${DatabaseConfig.tripsTable}', '${DatabaseConfig.reviewsTable}')
        ''');
        
        if (tables.length < 2) {
          if (DatabaseConfig.enableSqlLogging) {
            print('${DatabaseConfig.logPrefix} ❌ Tablas principales no encontradas');
          }
          return false;
        }
      }

      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ✅ Migración verificada correctamente');
      }
      
      return true;
    } catch (e) {
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ❌ Error verificando migración: $e');
      }
      return false;
    }
  }

  // ========================================
  // BACKUP ANTES DE MIGRACIÓN
  // ========================================

  /// Crear backup antes de migración (opcional)
  static Future<String?> createBackupBeforeMigration(Database db) async {
    try {
      // Esta funcionalidad se puede implementar copiando el archivo DB
      // Por ahora retornamos null, pero se puede expandir
      
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} Backup antes de migración (pendiente implementar)');
      }
      
      return null;
    } catch (e) {
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ⚠️ Error creando backup: $e');
      }
      return null;
    }
  }

  // ========================================
  // LIMPIEZA POST-MIGRACIÓN
  // ========================================

  /// Limpiar datos temporales después de migración exitosa
  static Future<void> cleanupAfterMigration(Database db, int fromVersion, int toVersion) async {
    try {
      // Optimizar base de datos después de cambios estructurales
      await db.execute('VACUUM;');
      await db.execute('ANALYZE;');
      
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ✅ Limpieza post-migración completada');
      }
    } catch (e) {
      // No es crítico si falla la limpieza
      if (DatabaseConfig.enableSqlLogging) {
        print('${DatabaseConfig.logPrefix} ⚠️ Error en limpieza post-migración: $e');
      }
    }
  }

  // ========================================
  // INFORMACIÓN DE MIGRACIÓN
  // ========================================

  /// Obtener información sobre migraciones disponibles
  static Map<String, dynamic> getMigrationInfo() {
    return {
      'current_version': DatabaseConfig.databaseVersion,
      'target_version_with_sync': DatabaseConfig.databaseVersionWithSync,
      'available_migrations': {
        '1_to_2': 'Optimizaciones para sincronización con backend',
        '2_to_3': 'Ejemplo para futuras mejoras (distancia de viajes)',
      },
      'migration_features': {
        'savepoint_rollback': true,
        'integrity_check': true,
        'backup_support': false, // Por implementar
      }
    };
  }
}

/// Excepción personalizada para errores de migración
class MigrationException implements Exception {
  final String message;
  const MigrationException(this.message);
  
  @override
  String toString() => 'MigrationException: $message';
}
