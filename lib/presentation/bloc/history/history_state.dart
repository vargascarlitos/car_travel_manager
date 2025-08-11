part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, loadingMore, success, failure }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.trips = const [],
    this.reachedEnd = false,
    this.offset = 0,
    this.failureMessage,
  });

  final HistoryStatus status;
  final List<Trip> trips;
  final bool reachedEnd;
  final int offset;
  final String? failureMessage;

  HistoryState copyWith({
    HistoryStatus? status,
    List<Trip>? trips,
    bool? reachedEnd,
    int? offset,
    String? failureMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      offset: offset ?? this.offset,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, trips, reachedEnd, offset, failureMessage];
}


