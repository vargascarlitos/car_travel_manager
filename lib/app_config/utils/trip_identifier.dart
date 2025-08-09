import 'dart:math' as math;

import '../../domain/entities/trip.dart';

/// Generador de identificadores numéricos legibles para mostrar al conductor
///
/// Mantiene el UUID como clave interna, pero expone un ID numérico estable
/// derivado del `uuid` y `createdAt`, con longitud fija (por defecto 8 dígitos).
class TripIdentifier {
  TripIdentifier._();

  /// Retorna un ID numérico determinístico de [digits] dígitos
  /// a partir de `uuid` y `createdAt`.
  static String fromUuidAndDate(
    String uuid,
    DateTime createdAt, {
    int digits = 8,
  }) {
    final epochSec = createdAt.toUtc().millisecondsSinceEpoch ~/ 1000;
    final uuidHash = uuid.hashCode & 0x7fffffff;
    final mixed = epochSec ^ uuidHash;
    final modulus = math.pow(10, digits).toInt();
    final code = (mixed % modulus).abs();
    return code.toString().padLeft(digits, '0');
  }

  /// Helper que recibe una entidad `Trip`.
  static String fromTrip(Trip trip, {int digits = 8}) {
    return fromUuidAndDate(trip.id, trip.createdAt, digits: digits);
  }
}


