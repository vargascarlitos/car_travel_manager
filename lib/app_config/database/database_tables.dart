import 'database_config.dart';

/// Scripts SQL para creación de tablas de TaxiMeter Pro
/// 
/// Contiene todos los DDL statements para crear la estructura completa
/// de la base de datos local, preparada para futuro backend.
class DatabaseTables {
  DatabaseTables._();

  // ========================================
  // TABLA PRINCIPAL: TRIPS
  // ========================================

  /// Script de creación de la tabla trips
  static const String createTripsTable = '''
    CREATE TABLE ${DatabaseConfig.tripsTable} (
      -- Identificación principal
      ${DatabaseConfig.fieldId} TEXT PRIMARY KEY NOT NULL,
      
      -- Datos del viaje
      ${DatabaseConfig.fieldPassengerName} TEXT NOT NULL CHECK (length(${DatabaseConfig.fieldPassengerName}) > 0),
      ${DatabaseConfig.fieldTotalAmount} INTEGER NOT NULL CHECK (${DatabaseConfig.fieldTotalAmount} > 0),
      ${DatabaseConfig.fieldServiceType} TEXT NOT NULL CHECK (${DatabaseConfig.fieldServiceType} IN ('economy', 'uberx', 'aire_ac')),
      
      -- Timestamps del viaje
      ${DatabaseConfig.fieldStartTime} TEXT NOT NULL,
      ${DatabaseConfig.fieldEndTime} TEXT NULL,
      ${DatabaseConfig.fieldDurationSeconds} INTEGER NULL CHECK (${DatabaseConfig.fieldDurationSeconds} >= 0),
      
      -- Estado del viaje
      ${DatabaseConfig.fieldStatus} TEXT NOT NULL CHECK (${DatabaseConfig.fieldStatus} IN ('pending', 'in_progress', 'completed')),
      
      -- Metadatos
      ${DatabaseConfig.fieldCreatedAt} TEXT NOT NULL,
      ${DatabaseConfig.fieldUpdatedAt} TEXT NOT NULL,
      
      -- Campos para sincronización futura (v2.0)
      ${DatabaseConfig.fieldServerId} TEXT NULL,
      ${DatabaseConfig.fieldIsSynced} INTEGER DEFAULT 0 CHECK (${DatabaseConfig.fieldIsSynced} IN (0, 1)),
      ${DatabaseConfig.fieldLastSyncedAt} TEXT NULL,
      ${DatabaseConfig.fieldIsDeleted} INTEGER DEFAULT 0 CHECK (${DatabaseConfig.fieldIsDeleted} IN (0, 1))
    );
  ''';

  // ========================================
  // TABLA SECUNDARIA: REVIEWS
  // ========================================

  /// Script de creación de la tabla reviews
  static const String createReviewsTable = '''
    CREATE TABLE ${DatabaseConfig.reviewsTable} (
      -- Identificación principal
      ${DatabaseConfig.fieldId} TEXT PRIMARY KEY NOT NULL,
      
      -- Relación con viaje
      ${DatabaseConfig.fieldTripId} TEXT NOT NULL,
      
      -- Datos de la reseña
      ${DatabaseConfig.fieldRating} INTEGER NOT NULL CHECK (${DatabaseConfig.fieldRating} >= ${DatabaseConfig.minRating} AND ${DatabaseConfig.fieldRating} <= ${DatabaseConfig.maxRating}),
      ${DatabaseConfig.fieldComment} TEXT NULL CHECK (length(${DatabaseConfig.fieldComment}) <= ${DatabaseConfig.maxCommentLength}),
      
      -- Metadatos
      ${DatabaseConfig.fieldCreatedAt} TEXT NOT NULL,
      
      -- Campos para sincronización futura (v2.0)
      ${DatabaseConfig.fieldServerId} TEXT NULL,
      ${DatabaseConfig.fieldIsSynced} INTEGER DEFAULT 0 CHECK (${DatabaseConfig.fieldIsSynced} IN (0, 1)),
      ${DatabaseConfig.fieldLastSyncedAt} TEXT NULL,
      ${DatabaseConfig.fieldIsDeleted} INTEGER DEFAULT 0 CHECK (${DatabaseConfig.fieldIsDeleted} IN (0, 1)),
      
      -- Relación con trips
      FOREIGN KEY (${DatabaseConfig.fieldTripId}) REFERENCES ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldId}) ON DELETE CASCADE
    );
  ''';

  // ========================================
  // TABLA FUTURA: SYNC METADATA (v2.0)
  // ========================================

  /// Script de creación de la tabla sync_metadata (futura)
  static const String createSyncMetadataTable = '''
    CREATE TABLE ${DatabaseConfig.syncMetadataTable} (
      ${DatabaseConfig.fieldId} TEXT PRIMARY KEY NOT NULL,
      last_full_sync TEXT NOT NULL,
      last_incremental_sync TEXT NOT NULL,
      pending_uploads INTEGER DEFAULT 0,
      sync_version INTEGER DEFAULT 1,
      ${DatabaseConfig.fieldCreatedAt} TEXT NOT NULL,
      ${DatabaseConfig.fieldUpdatedAt} TEXT NOT NULL
    );
  ''';

  // ========================================
  // ÍNDICES PARA PERFORMANCE
  // ========================================

  /// Índices principales para consultas frecuentes en TRIPS
  static const List<String> tripsIndices = [
    // Índice para ordenar por fecha (historial)
    '''CREATE INDEX idx_trips_created_at ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldCreatedAt} DESC);''',
    
    // Índice para filtrar por estado
    '''CREATE INDEX idx_trips_status ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldStatus});''',
    
    // Índice para filtrar por tipo de servicio
    '''CREATE INDEX idx_trips_service_type ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldServiceType});''',
    
    // Índice para buscar por nombre de pasajero
    '''CREATE INDEX idx_trips_passenger_name ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldPassengerName} COLLATE NOCASE);''',
    
    // Índice para consultas por fecha de actualización
    '''CREATE INDEX idx_trips_updated_at ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldUpdatedAt} DESC);''',
  ];

  /// Índices para la tabla REVIEWS
  static const List<String> reviewsIndices = [
    // Índice para relación trip_id
    '''CREATE INDEX idx_reviews_trip_id ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldTripId});''',
    
    // Índice para filtrar por rating
    '''CREATE INDEX idx_reviews_rating ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldRating});''',
    
    // Índice para ordenar por fecha
    '''CREATE INDEX idx_reviews_created_at ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldCreatedAt} DESC);''',
  ];

  /// Índices para sincronización futura
  static const List<String> syncIndices = [
    // Índices para optimizar sync de trips
    '''CREATE INDEX idx_trips_sync ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldIsSynced}, ${DatabaseConfig.fieldUpdatedAt});''',
    '''CREATE INDEX idx_trips_server_id ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldServerId});''',
    
    // Índices para optimizar sync de reviews
    '''CREATE INDEX idx_reviews_sync ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldIsSynced}, ${DatabaseConfig.fieldCreatedAt});''',
    '''CREATE INDEX idx_reviews_server_id ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldServerId});''',
  ];

  // ========================================
  // ÍNDICES ÚNICOS Y RESTRICCIONES
  // ========================================

  /// Restricción: Solo un viaje activo por vez
  static const String constraintSingleActiveTrip = '''
    CREATE UNIQUE INDEX idx_trips_single_active 
    ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldStatus}) 
    WHERE ${DatabaseConfig.fieldStatus} = 'in_progress';
  ''';

  /// Restricción: Una reseña por viaje
  static const String constraintOneReviewPerTrip = '''
    CREATE UNIQUE INDEX idx_reviews_one_per_trip 
    ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldTripId});
  ''';

  // ========================================
  // TRIGGERS PARA AUTOMATIZACIÓN
  // ========================================

  /// Trigger para actualizar updated_at automáticamente en trips
  static const String triggerTripsUpdatedAt = '''
    CREATE TRIGGER trigger_trips_updated_at 
    AFTER UPDATE ON ${DatabaseConfig.tripsTable}
    FOR EACH ROW
    WHEN NEW.${DatabaseConfig.fieldUpdatedAt} = OLD.${DatabaseConfig.fieldUpdatedAt}
    BEGIN
      UPDATE ${DatabaseConfig.tripsTable} 
      SET ${DatabaseConfig.fieldUpdatedAt} = datetime('now') 
      WHERE ${DatabaseConfig.fieldId} = NEW.${DatabaseConfig.fieldId};
    END;
  ''';

  /// Trigger para calcular duración automáticamente
  static const String triggerCalculateDuration = '''
    CREATE TRIGGER trigger_calculate_duration 
    AFTER UPDATE OF ${DatabaseConfig.fieldEndTime} ON ${DatabaseConfig.tripsTable}
    FOR EACH ROW
    WHEN NEW.${DatabaseConfig.fieldEndTime} IS NOT NULL 
    AND NEW.${DatabaseConfig.fieldStartTime} IS NOT NULL
    BEGIN
      UPDATE ${DatabaseConfig.tripsTable} 
      SET ${DatabaseConfig.fieldDurationSeconds} = (
        CAST((julianday(NEW.${DatabaseConfig.fieldEndTime}) - julianday(NEW.${DatabaseConfig.fieldStartTime})) * 86400 AS INTEGER)
      )
      WHERE ${DatabaseConfig.fieldId} = NEW.${DatabaseConfig.fieldId};
    END;
  ''';

  // ========================================
  // SCRIPTS DE MIGRACIÓN (v2.0)
  // ========================================

  /// Scripts para migración v1 → v2 (futura con backend)
  static const List<String> migrationV2Scripts = [
    // Los campos de sync ya están incluidos en v1
    // Estos son índices adicionales optimizados para sync
    '''CREATE INDEX idx_trips_sync_priority ON ${DatabaseConfig.tripsTable} (${DatabaseConfig.fieldIsSynced}, ${DatabaseConfig.fieldUpdatedAt}, ${DatabaseConfig.fieldStatus});''',
    '''CREATE INDEX idx_reviews_sync_priority ON ${DatabaseConfig.reviewsTable} (${DatabaseConfig.fieldIsSynced}, ${DatabaseConfig.fieldCreatedAt}, ${DatabaseConfig.fieldRating});''',
  ];

  // ========================================
  // SCRIPTS DE LIMPIEZA (MAINTENANCE)
  // ========================================

  /// Script para limpiar datos antiguos (opcional)
  static const String cleanupOldData = '''
    DELETE FROM ${DatabaseConfig.tripsTable} 
    WHERE ${DatabaseConfig.fieldIsDeleted} = 1 
    AND datetime(${DatabaseConfig.fieldUpdatedAt}) < datetime('now', '-30 days');
  ''';

  /// Script para optimizar base de datos
  static const String optimizeDatabase = '''
    VACUUM;
    ANALYZE;
  ''';

  // ========================================
  // LISTA DE TODOS LOS SCRIPTS
  // ========================================

  /// Obtener todos los scripts de creación de tablas
  static List<String> get allCreateTableScripts => [
    createTripsTable,
    createReviewsTable,
  ];

  /// Obtener todos los scripts de índices
  static List<String> get allIndexScripts => [
    ...tripsIndices,
    ...reviewsIndices,
    constraintSingleActiveTrip,
    constraintOneReviewPerTrip,
  ];

  /// Obtener todos los scripts de triggers
  static List<String> get allTriggerScripts => [
    triggerTripsUpdatedAt,
    triggerCalculateDuration,
  ];

  /// Obtener todos los scripts de índices de sync (para v2)
  static List<String> get allSyncIndexScripts => syncIndices;
}
