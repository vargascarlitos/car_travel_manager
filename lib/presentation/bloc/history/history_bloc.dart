import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bc;
import 'package:stream_transform/stream_transform.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';

part 'history_state.dart';
part 'history_event.dart';

/// EventTransformer combinado: throttle + droppable
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return bc.droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this._tripRepository) : super(const HistoryState()) {
    on<HistoryLoadInitial>(_onLoadInitial);
    on<HistoryLoadMore>(_onLoadMore, transformer: throttleDroppable(const Duration(milliseconds: 700)));
    on<HistoryRefresh>(_onRefresh);
    on<HistoryToggleDayCollapse>(_onToggleDayCollapse);
  }

  final TripRepository _tripRepository;
  static const int _pageSize = 20;

  Future<void> _onLoadInitial(HistoryLoadInitial event, Emitter<HistoryState> emit) async {
    if (state.status == HistoryStatus.loading) return;
    emit(state.copyWith(status: HistoryStatus.loading, trips: const [], reachedEnd: false, offset: 0));
    await _loadPage(reset: true, emit: emit);
  }

  Future<void> _onLoadMore(HistoryLoadMore event, Emitter<HistoryState> emit) async {
    if (state.reachedEnd || state.status == HistoryStatus.loadingMore) return;
    emit(state.copyWith(status: HistoryStatus.loadingMore));
    await _loadPage(reset: false, emit: emit);
  }

  Future<void> _onRefresh(HistoryRefresh event, Emitter<HistoryState> emit) async {
    await _onLoadInitial(const HistoryLoadInitial(), emit);
  }

  Future<void> _loadPage({required bool reset, required Emitter<HistoryState> emit}) async {
    try {
      final nextOffset = reset ? 0 : state.offset;
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

  void _onToggleDayCollapse(HistoryToggleDayCollapse event, Emitter<HistoryState> emit) {
    final normalized = DateTime(event.day.year, event.day.month, event.day.day);
    final newSet = Set<DateTime>.from(state.collapsedDays);
    if (newSet.contains(normalized)) {
      newSet.remove(normalized);
    } else {
      newSet.add(normalized);
    }
    emit(state.copyWith(collapsedDays: newSet));
  }
}


