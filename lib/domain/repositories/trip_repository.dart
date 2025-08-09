import '../entities/trip.dart';

/// Contrato de repositorio para gestión de viajes (offline-first)
abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<Trip?> getTripById(String id);
  Future<void> updateTrip(Trip trip);
}


