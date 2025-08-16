part of 'history_bloc.dart';

enum HistoryStatus { initial, loading, loadingMore, success, failure }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.trips = const [],
    this.reachedEnd = false,
    this.offset = 0,
    this.failureMessage,
    this.collapsedDays = const <DateTime>{},
  });

  final HistoryStatus status;
  final List<Trip> trips;
  final bool reachedEnd;
  final int offset;
  final String? failureMessage;
  /// Conjunto de días (normalizados a AAAA-MM-DD) que están colapsados
  final Set<DateTime> collapsedDays;

  HistoryState copyWith({
    HistoryStatus? status,
    List<Trip>? trips,
    bool? reachedEnd,
    int? offset,
    String? failureMessage,
    Set<DateTime>? collapsedDays,
  }) {
    return HistoryState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      offset: offset ?? this.offset,
      failureMessage: failureMessage ?? this.failureMessage,
      collapsedDays: collapsedDays ?? this.collapsedDays,
    );
  }

  @override
  List<Object?> get props => [status, trips, reachedEnd, offset, failureMessage, collapsedDays];
}


