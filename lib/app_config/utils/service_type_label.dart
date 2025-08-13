import '../../domain/entities/trip.dart';

/// Retorna la etiqueta en español y capitalizada para el tipo de servicio.
String serviceTypeLabel(ServiceType type) {
  switch (type) {
    case ServiceType.economy:
      return 'Económico';
    case ServiceType.uberX:
      return 'UberX';
    case ServiceType.aireAc:
      return 'Aire AC';
  }
}

