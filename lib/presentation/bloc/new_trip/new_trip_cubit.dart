import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import 'new_trip_state.dart';

class NewTripCubit extends Cubit<NewTripState> {
  NewTripCubit({required TripRepository tripRepository})
      : _tripRepository = tripRepository,
        super(const NewTripState());

  final TripRepository _tripRepository;

  void passengerNameChanged(String value) {
    final passengerName = PassengerName.dirty(value);
    emit(
      state.copyWith(
        passengerName: passengerName,
        status: FormStatus.initial,
        clearFailure: true,
        isValid: Formz.validate([
          passengerName,
          state.fareAmount,
        ]),
      ),
    );
  }

  void fareAmountChanged(String value) {
    final fareAmount = FareAmount.dirty(value);
    emit(
      state.copyWith(
        fareAmount: fareAmount,
        status: FormStatus.initial,
        clearFailure: true,
        isValid: Formz.validate([
          state.passengerName,
          fareAmount,
        ]),
      ),
    );
  }

  void serviceTypeChanged(ServiceType value) {
    emit(
      state.copyWith(
        serviceType: value,
        status: FormStatus.initial,
        clearFailure: true,
      ),
    );
  }

  Future<void> saveTrip() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormStatus.loading, clearFailure: true));

    try {
      final now = DateTime.now();
      final trip = Trip(
        id: const Uuid().v4(),
        passengerName: state.passengerName.value.trim(),
        totalAmount: state.fareAmount.numericValue!,
        serviceType: state.serviceType,
        // start_time no puede ser NULL según el schema actual
        // Guardamos now y podremos actualizarlo al iniciar el viaje real
        startTime: now,
        endTime: null,
        duration: null,
        status: TripStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      final saved = await _tripRepository.createTrip(trip);
      emit(state.copyWith(
        status: FormStatus.success,
        lastSavedTripId: saved.id,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormStatus.failure,
        failureMessage: 'No se pudo guardar el viaje. Intente de nuevo.',
      ));
    }
  }
}


