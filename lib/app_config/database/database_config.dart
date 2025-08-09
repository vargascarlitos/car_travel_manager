/// Configuración principal de la base de datos SQLite para TaxiMeter Pro
/// 
/// Contiene constantes, configuración y metadatos de la base de datos local.
/// Preparado para futuro backend con campos de sincronización.
class DatabaseConfig {
  DatabaseConfig._();

  // ========================================
  // CONFIGURACIÓN PRINCIPAL
  // ========================================

  /// Nombre del archivo de base de datos
  static const String databaseName = 'taximeter_pro.db';

  /// Versión actual de la base de datos
  static const int databaseVersion = 1;

  /// Versión preparada para backend (futura migración)
  static const int databaseVersionWithSync = 2;

  // ========================================
  // NOMBRES DE TABLAS
  // ========================================

  /// Tabla de viajes principales
  static const String tripsTable = 'trips';

  /// Tabla de reseñas del conductor
  static const String reviewsTable = 'reviews';

  /// Tabla de metadata de sincronización (futura)
  static const String syncMetadataTable = 'sync_metadata';

  // ========================================
  // CAMPOS COMPARTIDOS
  // ========================================

  /// Campo ID universal para todas las tablas
  static const String fieldId = 'id';

  /// Campo de timestamp de creación
  static const String fieldCreatedAt = 'created_at';

  /// Campo de timestamp de actualización
  static const String fieldUpdatedAt = 'updated_at';

  // ========================================
  // CAMPOS DE SINCRONIZACIÓN (FUTURO BACKEND)
  // ========================================

  /// ID asignado por el servidor
  static const String fieldServerId = 'server_id';

  /// Flag de sincronización (0 = no sync, 1 = sincronizado)
  static const String fieldIsSynced = 'is_synced';

  /// Timestamp de última sincronización exitosa
  static const String fieldLastSyncedAt = 'last_synced_at';

  /// Flag de soft delete para sincronización
  static const String fieldIsDeleted = 'is_deleted';

  // ========================================
  // CAMPOS ESPECÍFICOS - TRIPS
  // ========================================

  /// Nombre del pasajero
  static const String fieldPassengerName = 'passenger_name';

  /// Monto total en guaraníes (entero)
  static const String fieldTotalAmount = 'total_amount';

  /// Tipo de servicio (economy, uberx, aire_ac)
  static const String fieldServiceType = 'service_type';

  /// Timestamp de inicio del viaje
  static const String fieldStartTime = 'start_time';

  /// Timestamp de fin del viaje (nullable)
  static const String fieldEndTime = 'end_time';

  /// Duración del viaje en segundos
  static const String fieldDurationSeconds = 'duration_seconds';

  /// Estado del viaje (pending, in_progress, completed)
  static const String fieldStatus = 'status';

  // ========================================
  // CAMPOS ESPECÍFICOS - REVIEWS
  // ========================================

  /// ID del viaje asociado (foreign key)
  static const String fieldTripId = 'trip_id';

  /// Calificación 1-5 estrellas
  static const String fieldRating = 'rating';

  /// Comentario opcional del conductor (max 1000 chars)
  static const String fieldComment = 'comment';

  // ========================================
  // VALORES ENUM
  // ========================================

  /// Tipos de servicio válidos
  static const List<String> serviceTypes = [
    'economy',
    'uberx', 
    'aire_ac',
  ];

  /// Estados de viaje válidos
  static const List<String> tripStatuses = [
    'pending',      // Viaje creado, esperando inicio
    'in_progress',  // Viaje en curso
    'completed',    // Viaje finalizado
  ];

  /// Valores válidos para rating (1-5 estrellas)
  static const int minRating = 1;
  static const int maxRating = 5;

  /// Longitud máxima del comentario en reseñas
  static const int maxCommentLength = 1000;

  // ========================================
  // CONFIGURACIÓN DE PERFORMANCE
  // ========================================

  /// Tamaño de página para consultas paginadas
  static const int defaultPageSize = 20;

  /// Límite máximo de registros en consultas
  static const int maxQueryLimit = 1000;

  /// Timeout para operaciones de base de datos (segundos)
  static const int operationTimeoutSeconds = 30;

  // ========================================
  // PATHS Y UBICACIONES
  // ========================================

  /// Directorio de la aplicación para la base de datos
  static const String appDirectory = 'taximeter_pro';

  /// Nombre del directorio de backup (futuro)
  static const String backupDirectory = 'backups';

  // ========================================
  // VALIDACIONES
  // ========================================

  /// Validar tipo de servicio
  static bool isValidServiceType(String serviceType) {
    return serviceTypes.contains(serviceType.toLowerCase());
  }

  /// Validar estado de viaje
  static bool isValidTripStatus(String status) {
    return tripStatuses.contains(status.toLowerCase());
  }

  /// Validar rating de reseña
  static bool isValidRating(int rating) {
    return rating >= minRating && rating <= maxRating;
  }

  /// Validar longitud de comentario
  static bool isValidCommentLength(String? comment) {
    if (comment == null) return true;
    return comment.length <= maxCommentLength;
  }

  /// Validar monto de viaje
  static bool isValidAmount(int amount) {
    return amount > 0; // Debe ser positivo
  }

  // ========================================
  // UTILIDADES DE FORMATO
  // ========================================

  /// Formatear timestamp para SQLite (ISO 8601)
  static String formatTimestamp(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Parsear timestamp desde SQLite
  static DateTime parseTimestamp(String timestamp) {
    return DateTime.parse(timestamp);
  }

  /// Generar UUID para IDs (usando timestamp + random para offline)
  static String generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (DateTime.now().microsecondsSinceEpoch % 1000000);
    return 'trip_${now}_$random';
  }

  /// Generar ID para reseñas
  static String generateReviewId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (DateTime.now().microsecondsSinceEpoch % 1000000);
    return 'review_${now}_$random';
  }

  // ========================================
  // CONFIGURACIÓN DE DEBUG
  // ========================================

  /// Habilitar logs de SQL en desarrollo
  static const bool enableSqlLogging = true;

  /// Habilitar validaciones extra en desarrollo
  static const bool enableStrictValidation = true;

  /// Prefijo para logs de base de datos
  static const String logPrefix = '[TaxiMeter DB]';
}
