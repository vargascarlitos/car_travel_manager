import 'package:sqflite/sqflite.dart' as sqflite;
import '../../app_config/database/database_helper.dart' as appdb;
import '../models/trip_model.dart';

class TripLocalDataSource {
  TripLocalDataSource(this._dbHelper);

  final appdb.DatabaseHelper _dbHelper;

  static const String _table = 'trips';

  Future<TripModel> createTrip(TripModel trip) async {
    final values = trip.toMap();
    try {
      await _dbHelper.insert(_table, values);
      return trip;
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
}


