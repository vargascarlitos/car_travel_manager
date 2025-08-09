import 'package:equatable/equatable.dart';

/// Tipos de servicio permitidos para un viaje
enum ServiceType { economy, uberX, aireAc }

/// Estado del viaje dentro del flujo de la app
enum TripStatus { pending, inProgress, completed }

/// Entidad de dominio que representa un viaje (inmutable)
class Trip extends Equatable {
  const Trip({
    required this.id,
    required this.passengerName,
    required this.totalAmount,
    required this.serviceType,
    this.startTime,
    this.endTime,
    this.duration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;                // UUID
  final String passengerName;     // Nombre del pasajero
  final int totalAmount;          // Monto en Gs (entero)
  final ServiceType serviceType;  // Tipo de servicio
  final DateTime? startTime;      // Inicio (puede ser null si aún no inicia)
  final DateTime? endTime;        // Fin (null si no completado)
  final Duration? duration;       // Duración (derivable)
  final TripStatus status;        // pending, inProgress, completed
  final DateTime createdAt;       // Fecha de creación
  final DateTime updatedAt;       // Fecha de última actualización

  Trip copyWith({
    String? id,
    String? passengerName,
    int? totalAmount,
    ServiceType? serviceType,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    TripStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      passengerName: passengerName ?? this.passengerName,
      totalAmount: totalAmount ?? this.totalAmount,
      serviceType: serviceType ?? this.serviceType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        passengerName,
        totalAmount,
        serviceType,
        startTime,
        endTime,
        duration,
        status,
        createdAt,
        updatedAt,
      ];
}


