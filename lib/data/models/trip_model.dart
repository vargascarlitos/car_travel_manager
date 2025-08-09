import 'package:equatable/equatable.dart';
import '../../domain/entities/trip.dart';

/// Modelo de datos para persistencia en SQLite
class TripModel extends Equatable {
  const TripModel({
    required this.id,
    required this.passengerName,
    required this.totalAmount,
    required this.serviceType,
    this.startTime,
    this.endTime,
    this.durationSeconds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String passengerName;
  final int totalAmount;
  final ServiceType serviceType;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? durationSeconds;
  final TripStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trip toEntity() {
    return Trip(
      id: id,
      passengerName: passengerName,
      totalAmount: totalAmount,
      serviceType: serviceType,
      startTime: startTime,
      endTime: endTime,
      duration: durationSeconds != null ? Duration(seconds: durationSeconds!) : null,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: trip.id,
      passengerName: trip.passengerName,
      totalAmount: trip.totalAmount,
      serviceType: trip.serviceType,
      startTime: trip.startTime,
      endTime: trip.endTime,
      durationSeconds: trip.duration?.inSeconds,
      status: trip.status,
      createdAt: trip.createdAt,
      updatedAt: trip.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passenger_name': passengerName,
      'total_amount': totalAmount,
      'service_type': _serviceTypeToDb(serviceType),
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'status': _statusToDb(status),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] as String,
      passengerName: map['passenger_name'] as String,
      totalAmount: map['total_amount'] as int,
      serviceType: _serviceTypeFromDb(map['service_type'] as String),
      startTime: (map['start_time'] as String?) != null ? DateTime.parse(map['start_time'] as String) : null,
      endTime: (map['end_time'] as String?) != null ? DateTime.parse(map['end_time'] as String) : null,
      durationSeconds: map['duration_seconds'] as int?,
      status: _statusFromDb(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  static String _serviceTypeToDb(ServiceType type) {
    switch (type) {
      case ServiceType.economy:
        return 'economy';
      case ServiceType.uberX:
        return 'uberx';
      case ServiceType.aireAc:
        return 'aire_ac';
    }
  }

  static ServiceType _serviceTypeFromDb(String value) {
    switch (value) {
      case 'economy':
        return ServiceType.economy;
      case 'uberx':
        return ServiceType.uberX;
      case 'aire_ac':
        return ServiceType.aireAc;
      default:
        return ServiceType.economy;
    }
  }

  static String _statusToDb(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return 'pending';
      case TripStatus.inProgress:
        return 'in_progress';
      case TripStatus.completed:
        return 'completed';
    }
  }

  static TripStatus _statusFromDb(String value) {
    switch (value) {
      case 'pending':
        return TripStatus.pending;
      case 'in_progress':
        return TripStatus.inProgress;
      case 'completed':
        return TripStatus.completed;
      default:
        return TripStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        passengerName,
        totalAmount,
        serviceType,
        startTime,
        endTime,
        durationSeconds,
        status,
        createdAt,
        updatedAt,
      ];
}


