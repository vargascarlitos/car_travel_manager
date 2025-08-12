import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._tripRepository) : super(const HistoryState());

  final TripRepository _tripRepository;

  static const int _pageSize = 20;

  Future<void> loadInitial() async {
    if (state.status == HistoryStatus.loading) return;
    emit(state.copyWith(status: HistoryStatus.loading, trips: [], reachedEnd: false, offset: 0));
    await _loadPage(reset: true);
  }

  Future<void> loadMore() async {
    if (state.reachedEnd || state.status == HistoryStatus.loadingMore) return;
    emit(state.copyWith(status: HistoryStatus.loadingMore));
    await _loadPage(reset: false);
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<void> _loadPage({required bool reset}) async {
    try {
      final nextOffset = reset ? 0 : state.offset;
      // Mostrar solo viajes completados en historial
      final result = await _tripRepository.getTrips(
        limit: _pageSize,
        offset: nextOffset,
        status: TripStatus.completed,
      );
      final reachedEnd = result.length < _pageSize;
      final updated = reset ? result : [...state.trips, ...result];
      emit(state.copyWith(
        status: HistoryStatus.success,
        trips: updated,
        reachedEnd: reachedEnd,
        offset: nextOffset + result.length,
      ));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.failure, failureMessage: e.toString()));
    }
  }
}


