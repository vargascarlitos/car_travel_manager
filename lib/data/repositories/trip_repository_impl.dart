import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../models/trip_model.dart';
import '../datasources/trip_local_datasource.dart';
import '../../app_config/database/database_helper.dart' as appdb;

class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(appdb.DatabaseHelper dbHelper)
      : _localDataSource = TripLocalDataSource(dbHelper);

  final TripLocalDataSource _localDataSource;

  @override
  Future<Trip> createTrip(Trip trip) async {
    try {
      final model = TripModel.fromEntity(trip);
      final saved = await _localDataSource.createTrip(model);
      return saved.toEntity();
    } on appdb.DatabaseException {
      rethrow;
    } catch (error) {
      throw appdb.DatabaseException('Failed to create trip: $error');
    }
  }

  @override
  Future<Trip?> getTripById(String id) async {
    try {
      final model = await _localDataSource.getTripById(id);
      return model?.toEntity();
    } on appdb.DatabaseException {
      rethrow;
    } catch (error) {
      throw appdb.DatabaseException('Failed to get trip: $error');
    }
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    try {
      final model = TripModel.fromEntity(trip);
      await _localDataSource.updateTrip(model);
    } on appdb.DatabaseException {
      rethrow;
    } catch (error) {
      throw appdb.DatabaseException('Failed to update trip: $error');
    }
  }

  @override
  Future<List<Trip>> getTrips({int limit = 20, int offset = 0}) async {
    try {
      final models = await _localDataSource.getTrips(limit: limit, offset: offset);
      return models.map((m) => m.toEntity()).toList();
    } on appdb.DatabaseException {
      rethrow;
    } catch (error) {
      throw appdb.DatabaseException('Failed to list trips: $error');
    }
  }
}


