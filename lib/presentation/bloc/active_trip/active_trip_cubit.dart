import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../timer/timer_cubit.dart';
import 'active_trip_state.dart';

class ActiveTripCubit extends Cubit<ActiveTripState> {
  ActiveTripCubit({
    required TripRepository repository,
    required TimerCubit timer,
  })  : _repository = repository,
        _timer = timer,
        super(const ActiveTripState());

  final TripRepository _repository;
  final TimerCubit _timer;

  Future<void> startTrip(String tripId) async {
    emit(state.copyWith(status: ActiveTripStatus.loading, clearFailure: true));
    try {
      final trip = await _repository.getTripById(tripId);
      if (trip == null) {
        emit(state.copyWith(status: ActiveTripStatus.failure, failureMessage: 'Viaje no encontrado'));
        return;
      }

      // Requisito: no persistir cambios al ingresar; solo comenzar cronómetro.
      // Mantener datos originales; usar estado inProgress solo a nivel de UI.
      _timer.start();
      emit(state.copyWith(status: ActiveTripStatus.inProgress, trip: trip));
    } catch (e) {
      emit(state.copyWith(status: ActiveTripStatus.failure, failureMessage: 'No se pudo iniciar el viaje'));
    }
  }

  Future<void> finishTrip() async {
    try {
      final current = state.trip;
      if (current == null) return;
      _timer.stop();
      final elapsed = _timer.elapsed;
      final updated = current.copyWith(
        status: TripStatus.completed,
        endTime: DateTime.now(),
        duration: elapsed,
      );
      await _repository.updateTrip(updated);
      emit(state.copyWith(status: ActiveTripStatus.completed, trip: updated));
    } catch (e) {
      emit(state.copyWith(status: ActiveTripStatus.failure, failureMessage: 'No se pudo finalizar el viaje'));
    }
  }

  Future<void> refreshTrip() async {
    try {
      final id = state.trip?.id;
      if (id == null) return;
      final fresh = await _repository.getTripById(id);
      if (fresh != null) {
        emit(state.copyWith(trip: fresh));
      }
    } catch (_) {
      // Silencioso; mantenemos UI estable
    }
  }
}


