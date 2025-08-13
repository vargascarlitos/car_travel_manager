import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../domain/entities/trip.dart';

// Status genérico para formularios
enum FormStatus { initial, loading, success, failure }

// Validación de nombre de pasajero
enum PassengerNameValidationError { empty, tooShort, invalid }

class PassengerName extends FormzInput<String, PassengerNameValidationError> {
  const PassengerName.pure() : super.pure('');
  const PassengerName.dirty([super.value = '']) : super.dirty();

  @override
  PassengerNameValidationError? validator(String value) {
    if (value.trim().isEmpty) return PassengerNameValidationError.empty;
    if (value.trim().length < 2) return PassengerNameValidationError.tooShort;
    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegex.hasMatch(value.trim())) return PassengerNameValidationError.invalid;
    return null;
  }

  String? get errorMessage {
    if (isNotValid) {
      switch (error) {
        case PassengerNameValidationError.empty:
          return 'El nombre del pasajero es obligatorio';
        case PassengerNameValidationError.tooShort:
          return 'El nombre debe tener al menos 2 caracteres';
        case PassengerNameValidationError.invalid:
          return 'Solo se permiten letras y espacios';
        default:
          return null;
      }
    }
    return null;
  }
}

// Validación de monto en guaraníes
enum FareAmountValidationError { empty, invalid, tooLow, tooHigh }

class FareAmount extends FormzInput<String, FareAmountValidationError> {
  const FareAmount.pure() : super.pure('');
  const FareAmount.dirty([super.value = '']) : super.dirty();

  static const int minAmount = 5000;
  static const int maxAmount = 100000000;

  @override
  FareAmountValidationError? validator(String value) {
    if (value.isEmpty) return FareAmountValidationError.empty;
    final clean = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(clean);
    if (amount == null) return FareAmountValidationError.invalid;
    if (amount < minAmount) return FareAmountValidationError.tooLow;
    if (amount > maxAmount) return FareAmountValidationError.tooHigh;
    return null;
  }

  int? get numericValue {
    if (!isValid) return null;
    final clean = value.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(clean);
  }

  String? get errorMessage {
    if (isNotValid) {
      switch (error) {
        case FareAmountValidationError.empty:
          return 'El monto es obligatorio';
        case FareAmountValidationError.invalid:
          return 'Ingrese un monto válido';
        case FareAmountValidationError.tooLow:
          return 'El monto mínimo es Gs 5.000';
        case FareAmountValidationError.tooHigh:
          return 'El monto máximo es Gs 1.000.000';
        default:
          return null;
      }
    }
    return null;
  }
}

class NewTripState extends Equatable {
  const NewTripState({
    this.status = FormStatus.initial,
    this.passengerName = const PassengerName.pure(),
    this.fareAmount = const FareAmount.pure(),
    this.serviceType = ServiceType.economy,
    this.failureMessage,
    this.isValid = false,
    this.lastSavedTripId,
  });

  final FormStatus status;
  final PassengerName passengerName;
  final FareAmount fareAmount;
  final ServiceType serviceType;
  final String? failureMessage; // Simple string para UI amigable
  final bool isValid;
  final String? lastSavedTripId;

  NewTripState copyWith({
    FormStatus? status,
    PassengerName? passengerName,
    FareAmount? fareAmount,
    ServiceType? serviceType,
    String? failureMessage,
    bool clearFailure = false,
    bool? isValid,
    String? lastSavedTripId,
  }) {
    return NewTripState(
      status: status ?? this.status,
      passengerName: passengerName ?? this.passengerName,
      fareAmount: fareAmount ?? this.fareAmount,
      serviceType: serviceType ?? this.serviceType,
      failureMessage: clearFailure ? null : (failureMessage ?? this.failureMessage),
      isValid: isValid ?? this.isValid,
      lastSavedTripId: lastSavedTripId ?? this.lastSavedTripId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        passengerName,
        fareAmount,
        serviceType,
        failureMessage,
        isValid,
        lastSavedTripId,
      ];
}


