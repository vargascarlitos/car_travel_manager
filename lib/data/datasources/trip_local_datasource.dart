import 'package:sqflite/sqflite.dart' as sqflite;
import '../../app_config/database/database_helper.dart' as appdb;
import '../models/trip_model.dart';

class TripLocalDataSource {
  TripLocalDataSource(this._dbHelper);

  final appdb.DatabaseHelper _dbHelper;

  static const String _table = 'trips';

  Future<TripModel> createTrip(TripModel trip) async {
    try {
      // Garantizar secuencialidad con transacción
      return await _dbHelper.transaction<TripModel>((txn) async {
        final res = await txn.rawQuery('SELECT COALESCE(MAX(display_id), 0) + 1 as next FROM $_table');
        final nextRaw = res.first['next'];
        final int nextDisplayId = (nextRaw is int) ? nextRaw : int.parse(nextRaw.toString());

        final values = trip.toMap();
        values['display_id'] = nextDisplayId;

        await txn.insert(_table, values, conflictAlgorithm: sqflite.ConflictAlgorithm.abort);

        return TripModel(
          id: trip.id,
          displayId: nextDisplayId,
          passengerName: trip.passengerName,
          totalAmount: trip.totalAmount,
          serviceType: trip.serviceType,
          startTime: trip.startTime,
          endTime: trip.endTime,
          durationSeconds: trip.durationSeconds,
          status: trip.status,
          createdAt: trip.createdAt,
          updatedAt: trip.updatedAt,
        );
      });
    } on sqflite.DatabaseException catch (e) {
      throw appdb.DatabaseException('Error al crear viaje: ${e.toString()}');
    } catch (e) {
      throw appdb.DatabaseException('Error al crear viaje: $e');
    }
  }

  Future<TripModel?> getTripById(String id) async {
    try {
      final result = await _dbHelper.query(
        _table,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return TripModel.fromMap(result.first);
    } on sqflite.DatabaseException catch (e) {
      throw appdb.DatabaseException('Error al obtener viaje: ${e.toString()}');
    } catch (e) {
      throw appdb.DatabaseException('Error al obtener viaje: $e');
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    try {
      final values = Map<String, dynamic>.from(trip.toMap())
        ..removeWhere((key, value) => value == null)
        ..remove('id');
      await _dbHelper.update(
        _table,
        values,
        where: 'id = ?',
        whereArgs: [trip.id],
      );
    } on sqflite.DatabaseException catch (e) {
      throw appdb.DatabaseException('Error al actualizar viaje: ${e.toString()}');
    } catch (e) {
      throw appdb.DatabaseException('Error al actualizar viaje: $e');
    }
  }
}


