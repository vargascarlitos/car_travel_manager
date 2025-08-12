import '../entities/trip.dart';

/// Contrato de repositorio para gestión de viajes (offline-first)
abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<Trip?> getTripById(String id);
  Future<void> updateTrip(Trip trip);
  /// Obtiene viajes paginados ordenados por created_at DESC
  /// Puede filtrar por [status] si se provee.
  Future<List<Trip>> getTrips({int limit = 20, int offset = 0, TripStatus? status});
}


