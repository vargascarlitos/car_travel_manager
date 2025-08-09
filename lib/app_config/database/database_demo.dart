import '../database_config.dart';

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
      
      print('✅ Viaje creado con ID: $tripId');
      return tripId;
    } catch (e) {
      print('❌ Error creando viaje: $e');
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
        print('✅ Viaje $tripId iniciado');
      } else {
        print('⚠️ No se encontró el viaje $tripId');
      }
    } catch (e) {
      print('❌ Error iniciando viaje: $e');
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
        print('✅ Viaje $tripId completado');
      } else {
        print('⚠️ No se encontró el viaje $tripId');
      }
    } catch (e) {
      print('❌ Error completando viaje: $e');
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
      
      print('✅ Reseña creada con ID: $reviewId');
      return reviewId;
    } catch (e) {
      print('❌ Error creando reseña: $e');
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
      
      print('📋 Encontrados ${trips.length} viajes');
      return trips;
    } catch (e) {
      print('❌ Error obteniendo viajes: $e');
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
      
      print('📋 Encontrados ${trips.length} viajes con estado: $status');
      return trips;
    } catch (e) {
      print('❌ Error obteniendo viajes por estado: $e');
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
        print('⭐ Reseña encontrada para viaje $tripId');
        return reviews.first;
      } else {
        print('📝 No hay reseña para viaje $tripId');
        return null;
      }
    } catch (e) {
      print('❌ Error obteniendo reseña: $e');
      rethrow;
    }
  }

  // ========================================
  // DEMO COMPLETO
  // ========================================

  /// Ejecutar demo completo de la base de datos
  static Future<void> runCompleteDemo() async {
    print('\n🚀 === DEMO COMPLETO DE BASE DE DATOS ===\n');
    
    try {
      // 1. Crear viaje
      print('1️⃣ Creando viaje...');
      final tripId = await createSampleTrip();
      
      // 2. Iniciar viaje
      print('\n2️⃣ Iniciando viaje...');
      await startTrip(tripId);
      
      // 3. Simular tiempo de viaje
      print('\n3️⃣ Simulando viaje en curso...');
      await Future.delayed(Duration(seconds: 1));
      
      // 4. Completar viaje
      print('\n4️⃣ Completando viaje...');
      await completeTrip(tripId);
      
      // 5. Crear reseña
      print('\n5️⃣ Creando reseña...');
      final reviewId = await createSampleReview(tripId);
      
      // 6. Consultar datos
      print('\n6️⃣ Consultando datos...');
      final allTrips = await getAllTrips();
      final completedTrips = await getTripsByStatus('completed');
      final review = await getReviewForTrip(tripId);
      
      // 7. Mostrar resultados
      print('\n📊 === RESULTADOS ===');
      print('Total viajes: ${allTrips.length}');
      print('Viajes completados: ${completedTrips.length}');
      print('Reseña del viaje: ${review != null ? "${review[DatabaseConfig.fieldRating]} estrellas" : "Sin reseña"}');
      
      // 8. Info de la base de datos
      print('\n8️⃣ Información de la base de datos...');
      final dbHelper = DatabaseHelper();
      final dbInfo = await dbHelper.getDatabaseInfo();
      print('Versión: ${dbInfo['version']}');
      print('Tamaño: ${dbInfo['size_mb']} MB');
      
      print('\n✅ === DEMO COMPLETADO EXITOSAMENTE ===\n');
      
    } catch (e) {
      print('\n❌ === ERROR EN DEMO ===');
      print('Error: $e');
      print('');
    }
  }

  // ========================================
  // DEMO DE VALIDACIONES
  // ========================================

  /// Demostrar validaciones de la base de datos
  static Future<void> runValidationDemo() async {
    print('\n🔒 === DEMO DE VALIDACIONES ===\n');
    
    // Test validaciones de configuración
    print('1️⃣ Validando tipos de servicio...');
    print('  economy: ${DatabaseConfig.isValidServiceType('economy')}');
    print('  invalid: ${DatabaseConfig.isValidServiceType('invalid')}');
    
    print('\n2️⃣ Validando estados de viaje...');
    print('  in_progress: ${DatabaseConfig.isValidTripStatus('in_progress')}');
    print('  invalid: ${DatabaseConfig.isValidTripStatus('invalid')}');
    
    print('\n3️⃣ Validando ratings...');
    print('  5 estrellas: ${DatabaseConfig.isValidRating(5)}');
    print('  0 estrellas: ${DatabaseConfig.isValidRating(0)}');
    print('  10 estrellas: ${DatabaseConfig.isValidRating(10)}');
    
    print('\n4️⃣ Validando montos...');
    print('  25000: ${DatabaseConfig.isValidAmount(25000)}');
    print('  -100: ${DatabaseConfig.isValidAmount(-100)}');
    print('  0: ${DatabaseConfig.isValidAmount(0)}');
    
    print('\n✅ === VALIDACIONES COMPLETADAS ===\n');
  }

  // ========================================
  // DEMO DE CONSTRAINTS
  // ========================================

  /// Demostrar constraints de la base de datos
  static Future<void> runConstraintsDemo() async {
    print('\n🛡️ === DEMO DE CONSTRAINTS ===\n');
    
    final db = DatabaseHelper();
    
    try {
      // Test: Solo un viaje activo
      print('1️⃣ Probando constraint: solo un viaje activo...');
      
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
      
      print('  ✅ Primer viaje activo creado');
      
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
        
        print('  ❌ ERROR: Se permitió crear segundo viaje activo');
      } catch (e) {
        print('  ✅ Constraint funcionando: $e');
      }
      
      // Limpiar datos de prueba
      await db.delete(
        DatabaseConfig.tripsTable,
        where: '${DatabaseConfig.fieldId} IN (?, ?)',
        whereArgs: [trip1Id, trip2Id],
      );
      
      print('\n✅ === CONSTRAINTS VALIDADOS ===\n');
      
    } catch (e) {
      print('❌ Error en demo de constraints: $e');
    }
  }
}
