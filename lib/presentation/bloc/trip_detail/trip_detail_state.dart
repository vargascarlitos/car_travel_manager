part of 'trip_detail_cubit.dart';

enum TripDetailStatus { initial, loading, success, failure }

class TripDetailState extends Equatable {
  const TripDetailState({
    this.status = TripDetailStatus.initial,
    this.trip,
    this.review,
    this.failureMessage,
  });

  final TripDetailStatus status;
  final Trip? trip;
  final Review? review;
  final String? failureMessage;

  TripDetailState copyWith({
    TripDetailStatus? status,
    Trip? trip,
    Review? review,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return TripDetailState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      review: review ?? this.review,
      failureMessage: clearFailure ? null : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [status, trip, review, failureMessage];
}


