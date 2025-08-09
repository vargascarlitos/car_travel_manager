import 'package:equatable/equatable.dart';
import '../../../domain/entities/trip.dart';

enum ActiveTripStatus { initial, loading, inProgress, completed, failure }

class ActiveTripState extends Equatable {
  const ActiveTripState({
    this.status = ActiveTripStatus.initial,
    this.trip,
    this.failureMessage,
  });

  final ActiveTripStatus status;
  final Trip? trip;
  final String? failureMessage;

  ActiveTripState copyWith({
    ActiveTripStatus? status,
    Trip? trip,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return ActiveTripState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      failureMessage: clearFailure ? null : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [status, trip, failureMessage];
}


