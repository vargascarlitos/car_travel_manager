part of 'pending_recovery_cubit.dart';

enum PendingRecoveryStatus { initial, loading, success, failure }

class PendingRecoveryState extends Equatable {
  const PendingRecoveryState({
    this.status = PendingRecoveryStatus.initial,
    this.trips = const <Trip>[],
    this.failureMessage,
  });

  final PendingRecoveryStatus status;
  final List<Trip> trips;
  final String? failureMessage;

  PendingRecoveryState copyWith({
    PendingRecoveryStatus? status,
    List<Trip>? trips,
    String? failureMessage,
  }) {
    return PendingRecoveryState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, trips, failureMessage];
}


