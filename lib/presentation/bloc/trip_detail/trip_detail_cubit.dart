import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../domain/repositories/review_repository.dart';

part 'trip_detail_state.dart';

class TripDetailCubit extends Cubit<TripDetailState> {
  TripDetailCubit({
    required TripRepository tripRepository,
    required ReviewRepository reviewRepository,
    required String tripId,
  })  : _tripRepository = tripRepository,
        _reviewRepository = reviewRepository,
        _tripId = tripId,
        super(const TripDetailState());

  final TripRepository _tripRepository;
  final ReviewRepository _reviewRepository;
  final String _tripId;

  Future<void> load() async {
    emit(state.copyWith(status: TripDetailStatus.loading, clearFailure: true));
    try {
      final tripFuture = _tripRepository.getTripById(_tripId);
      final reviewFuture = _reviewRepository.getByTripId(_tripId);
      final results = await Future.wait([tripFuture, reviewFuture]);
      final Trip? trip = results[0] as Trip?;
      final Review? review = results[1] as Review?;
      if (trip == null) {
        emit(state.copyWith(status: TripDetailStatus.failure, failureMessage: 'Viaje no encontrado'));
        return;
      }
      emit(state.copyWith(status: TripDetailStatus.success, trip: trip, review: review));
    } catch (e) {
      emit(state.copyWith(status: TripDetailStatus.failure, failureMessage: 'No se pudo cargar el detalle'));
    }
  }
}


