import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import 'preview_state.dart';

/// Cubit para cargar y exponer la información del viaje en la pantalla Preview
class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit({required TripRepository tripRepository})
      : _tripRepository = tripRepository,
        super(const PreviewState());

  final TripRepository _tripRepository;

  Future<void> load(String tripId) async {
    emit(state.copyWith(status: PreviewStatus.loading, clearFailure: true));
    try {
      final Trip? trip = await _tripRepository.getTripById(tripId);
      if (trip == null) {
        emit(state.copyWith(
          status: PreviewStatus.failure,
          failureMessage: 'Viaje no encontrado',
        ));
        return;
      }
      emit(state.copyWith(status: PreviewStatus.success, trip: trip));
    } catch (e) {
      emit(state.copyWith(
        status: PreviewStatus.failure,
        failureMessage: 'Error al cargar el viaje',
      ));
    }
  }
}


