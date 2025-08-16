import '../database_config.dart';
import '../utils/logger.dart';

/// Demo de uso de la base de datos SQLite para TaxiMeter Pro
/// 
/// Ejemplo práctico de cómo usar la configuración de base de datos
/// para operaciones CRUD básicas con trips y reviews.
class DatabaseDemo {
  DatabaseDemo._();

  // ========================================
  // DEMO DE TRIPS
  // ========================================

  /// Crear un viaje de ejemplo
  static Future<String> createSampleTrip() async {
    final db = DatabaseHelper();
    
    try {
      final tripId = DatabaseConfig.generateId();
      final now = DateTime.now();
      
      await db.insert(DatabaseConfig.tripsTable, {
        DatabaseConfig.fieldId: tripId,
        DatabaseConfig.fieldPassengerName: 'María González',
        DatabaseConfig.fieldTotalAmount: 25000, // Gs 25.000
        DatabaseConfig.fieldServiceType: 'economy',
        DatabaseConfig.fieldStartTime: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldStatus: 'pending',
        DatabaseConfig.fieldCreatedAt: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldIsSynced: 0,
        DatabaseConfig.fieldIsDeleted: 0,
      });
      
      MyLogger.log('✅ Viaje creado con ID: $tripId');
      return tripId;
    } catch (e) {
      MyLogger.log('❌ Error creando viaje: $e');
      rethrow;
    }
  }

  /// Iniciar un viaje (cambiar estado a in_progress)
  static Future<void> startTrip(String tripId) async {
    final db = DatabaseHelper();
    
    try {
      final now = DateTime.now();
      
      final updated = await db.update(
        DatabaseConfig.tripsTable,
        {
          DatabaseConfig.fieldStatus: 'in_progress',
          DatabaseConfig.fieldStartTime: DatabaseConfig.formatTimestamp(now),
          DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(now),
        },
        where: '${DatabaseConfig.fieldId} = ?',
        whereArgs: [tripId],
      );
      
      if (updated > 0) {
        MyLogger.log('✅ Viaje $tripId iniciado');
      } else {
        MyLogger.log('⚠️ No se encontró el viaje $tripId');
      }
    } catch (e) {
      MyLogger.log('❌ Error iniciando viaje: $e');
      rethrow;
    }
  }

  /// Completar un viaje
  static Future<void> completeTrip(String tripId) async {
    final db = DatabaseHelper();
    
    try {
      final now = DateTime.now();
      
      final updated = await db.update(
        DatabaseConfig.tripsTable,
        {
          DatabaseConfig.fieldStatus: 'completed',
          DatabaseConfig.fieldEndTime: DatabaseConfig.formatTimestamp(now),
          DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(now),
        },
        where: '${DatabaseConfig.fieldId} = ?',
        whereArgs: [tripId],
      );
      
      if (updated > 0) {
        MyLogger.log('✅ Viaje $tripId completado');
      } else {
        MyLogger.log('⚠️ No se encontró el viaje $tripId');
      }
    } catch (e) {
      MyLogger.log('❌ Error completando viaje: $e');
      rethrow;
    }
  }

  // ========================================
  // DEMO DE REVIEWS
  // ========================================

  /// Crear una reseña para un viaje
  static Future<String> createSampleReview(String tripId) async {
    final db = DatabaseHelper();
    
    try {
      final reviewId = DatabaseConfig.generateReviewId();
      final now = DateTime.now();
      
      await db.insert(DatabaseConfig.reviewsTable, {
        DatabaseConfig.fieldId: reviewId,
        DatabaseConfig.fieldTripId: tripId,
        DatabaseConfig.fieldRating: 5,
        DatabaseConfig.fieldComment: 'Excelente viaje, pasajero muy amable',
        DatabaseConfig.fieldCreatedAt: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldIsSynced: 0,
        DatabaseConfig.fieldIsDeleted: 0,
      });
      
      MyLogger.log('✅ Reseña creada con ID: $reviewId');
      return reviewId;
    } catch (e) {
      MyLogger.log('❌ Error creando reseña: $e');
      rethrow;
    }
  }

  // ========================================
  // DEMO DE CONSULTAS
  // ========================================

  /// Obtener todos los viajes
  static Future<List<Map<String, dynamic>>> getAllTrips() async {
    final db = DatabaseHelper();
    
    try {
      final trips = await db.query(
        DatabaseConfig.tripsTable,
        orderBy: '${DatabaseConfig.fieldCreatedAt} DESC',
      );
      
      MyLogger.log('📋 Encontrados ${trips.length} viajes');
      return trips;
    } catch (e) {
      MyLogger.log('❌ Error obteniendo viajes: $e');
      rethrow;
    }
  }

  /// Obtener viajes por estado
  static Future<List<Map<String, dynamic>>> getTripsByStatus(String status) async {
    final db = DatabaseHelper();
    
    try {
      final trips = await db.query(
        DatabaseConfig.tripsTable,
        where: '${DatabaseConfig.fieldStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseConfig.fieldCreatedAt} DESC',
      );
      
      MyLogger.log('📋 Encontrados ${trips.length} viajes con estado: $status');
      return trips;
    } catch (e) {
      MyLogger.log('❌ Error obteniendo viajes por estado: $e');
      rethrow;
    }
  }

  /// Obtener reseña de un viaje
  static Future<Map<String, dynamic>?> getReviewForTrip(String tripId) async {
    final db = DatabaseHelper();
    
    try {
      final reviews = await db.query(
        DatabaseConfig.reviewsTable,
        where: '${DatabaseConfig.fieldTripId} = ?',
        whereArgs: [tripId],
        limit: 1,
      );
      
      if (reviews.isNotEmpty) {
        MyLogger.log('⭐ Reseña encontrada para viaje $tripId');
        return reviews.first;
      } else {
        MyLogger.log('📝 No hay reseña para viaje $tripId');
        return null;
      }
    } catch (e) {
      MyLogger.log('❌ Error obteniendo reseña: $e');
      rethrow;
    }
  }

  // ========================================
  // DEMO COMPLETO
  // ========================================

  /// Ejecutar demo completo de la base de datos
  static Future<void> runCompleteDemo() async {
    MyLogger.log('\n🚀 === DEMO COMPLETO DE BASE DE DATOS ===\n');
    
    try {
      // 1. Crear viaje
      MyLogger.log('1️⃣ Creando viaje...');
      final tripId = await createSampleTrip();
      
      // 2. Iniciar viaje
      MyLogger.log('\n2️⃣ Iniciando viaje...');
      await startTrip(tripId);
      
      // 3. Simular tiempo de viaje
      MyLogger.log('\n3️⃣ Simulando viaje en curso...');
      await Future.delayed(Duration(seconds: 1));
      
      // 4. Completar viaje
      MyLogger.log('\n4️⃣ Completando viaje...');
      await completeTrip(tripId);
      
      // 6. Consultar datos
      MyLogger.log('\n6️⃣ Consultando datos...');
      final allTrips = await getAllTrips();
      final completedTrips = await getTripsByStatus('completed');
      final review = await getReviewForTrip(tripId);
      
      // 7. Mostrar resultados
      MyLogger.log('\n📊 === RESULTADOS ===');
      MyLogger.log('Total viajes: ${allTrips.length}');
      MyLogger.log('Viajes completados: ${completedTrips.length}');
      MyLogger.log('Reseña del viaje: ${review != null ? "${review[DatabaseConfig.fieldRating]} estrellas" : "Sin reseña"}');
      
      // 8. Info de la base de datos
      MyLogger.log('\n8️⃣ Información de la base de datos...');
      final dbHelper = DatabaseHelper();
      final dbInfo = await dbHelper.getDatabaseInfo();
      MyLogger.log('Versión: ${dbInfo['version']}');
      MyLogger.log('Tamaño: ${dbInfo['size_mb']} MB');
      
      MyLogger.log('\n✅ === DEMO COMPLETADO EXITOSAMENTE ===\n');
      
    } catch (e) {
      MyLogger.log('\n❌ === ERROR EN DEMO ===');
      MyLogger.log('Error: $e');
      MyLogger.log('');
    }
  }

  // ========================================
  // DEMO DE VALIDACIONES
  // ========================================

  /// Demostrar validaciones de la base de datos
  static Future<void> runValidationDemo() async {
    MyLogger.log('\n🔒 === DEMO DE VALIDACIONES ===\n');
    
    // Test validaciones de configuración
    MyLogger.log('1️⃣ Validando tipos de servicio...');
    MyLogger.log('  economy: ${DatabaseConfig.isValidServiceType('economy')}');
    MyLogger.log('  invalid: ${DatabaseConfig.isValidServiceType('invalid')}');
    
    MyLogger.log('\n2️⃣ Validando estados de viaje...');
    MyLogger.log('  in_progress: ${DatabaseConfig.isValidTripStatus('in_progress')}');
    MyLogger.log('  invalid: ${DatabaseConfig.isValidTripStatus('invalid')}');
    
    MyLogger.log('\n3️⃣ Validando ratings...');
    MyLogger.log('  5 estrellas: ${DatabaseConfig.isValidRating(5)}');
    MyLogger.log('  0 estrellas: ${DatabaseConfig.isValidRating(0)}');
    MyLogger.log('  10 estrellas: ${DatabaseConfig.isValidRating(10)}');
    
    MyLogger.log('\n4️⃣ Validando montos...');
    MyLogger.log('  25000: ${DatabaseConfig.isValidAmount(25000)}');
    MyLogger.log('  -100: ${DatabaseConfig.isValidAmount(-100)}');
    MyLogger.log('  0: ${DatabaseConfig.isValidAmount(0)}');
    
    MyLogger.log('\n✅ === VALIDACIONES COMPLETADAS ===\n');
  }

  // ========================================
  // DEMO DE CONSTRAINTS
  // ========================================

  /// Demostrar constraints de la base de datos
  static Future<void> runConstraintsDemo() async {
    MyLogger.log('\n🛡️ === DEMO DE CONSTRAINTS ===\n');
    
    final db = DatabaseHelper();
    
    try {
      // Test: Solo un viaje activo
    MyLogger.log('1️⃣ Probando constraint: solo un viaje activo...');
      
      final trip1Id = DatabaseConfig.generateId();
      final trip2Id = DatabaseConfig.generateId();
      final now = DateTime.now();
      
      // Crear primer viaje activo
      await db.insert(DatabaseConfig.tripsTable, {
        DatabaseConfig.fieldId: trip1Id,
        DatabaseConfig.fieldPassengerName: 'Test 1',
        DatabaseConfig.fieldTotalAmount: 10000,
        DatabaseConfig.fieldServiceType: 'economy',
        DatabaseConfig.fieldStartTime: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldStatus: 'in_progress',
        DatabaseConfig.fieldCreatedAt: DatabaseConfig.formatTimestamp(now),
        DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(now),
      });
      
      MyLogger.log('  ✅ Primer viaje activo creado');
      
      // Intentar crear segundo viaje activo (debería fallar)
      try {
        await db.insert(DatabaseConfig.tripsTable, {
          DatabaseConfig.fieldId: trip2Id,
          DatabaseConfig.fieldPassengerName: 'Test 2',
          DatabaseConfig.fieldTotalAmount: 15000,
          DatabaseConfig.fieldServiceType: 'uberx',
          DatabaseConfig.fieldStartTime: DatabaseConfig.formatTimestamp(now),
          DatabaseConfig.fieldStatus: 'in_progress',
          DatabaseConfig.fieldCreatedAt: DatabaseConfig.formatTimestamp(now),
          DatabaseConfig.fieldUpdatedAt: DatabaseConfig.formatTimestamp(now),
        });
        
        MyLogger.log('  ❌ ERROR: Se permitió crear segundo viaje activo');
      } catch (e) {
        MyLogger.log('  ✅ Constraint funcionando: $e');
      }
      
      // Limpiar datos de prueba
      await db.delete(
        DatabaseConfig.tripsTable,
        where: '${DatabaseConfig.fieldId} IN (?, ?)',
        whereArgs: [trip1Id, trip2Id],
      );
      
      MyLogger.log('\n✅ === CONSTRAINTS VALIDADOS ===\n');
      
    } catch (e) {
      MyLogger.log('❌ Error en demo de constraints: $e');
    }
  }
}
