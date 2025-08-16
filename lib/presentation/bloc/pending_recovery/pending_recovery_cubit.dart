import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';

part 'pending_recovery_state.dart';

class PendingRecoveryCubit extends Cubit<PendingRecoveryState> {
  PendingRecoveryCubit(this._tripRepository) : super(const PendingRecoveryState());

  final TripRepository _tripRepository;

  Future<void> load() async {
    if (state.status == PendingRecoveryStatus.loading) return;
    emit(state.copyWith(status: PendingRecoveryStatus.loading));
    try {
      final trips = await _tripRepository.getTrips(
        limit: 50,
        offset: 0,
        status: TripStatus.pending,
      );
      emit(state.copyWith(status: PendingRecoveryStatus.success, trips: trips));
    } catch (e) {
      emit(state.copyWith(status: PendingRecoveryStatus.failure, failureMessage: e.toString()));
    }
  }
}


