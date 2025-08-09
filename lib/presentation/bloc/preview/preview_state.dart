import 'package:equatable/equatable.dart';
import '../../../domain/entities/trip.dart';

/// Estado para la pantalla de Previsualización
/// Cumple con Formz-Cubit patterns: status enum + copyWith
enum PreviewStatus { initial, loading, success, failure }

class PreviewState extends Equatable {
  const PreviewState({
    this.status = PreviewStatus.initial,
    this.trip,
    this.failureMessage,
  });

  final PreviewStatus status;
  final Trip? trip;
  final String? failureMessage;

  PreviewState copyWith({
    PreviewStatus? status,
    Trip? trip,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return PreviewState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      failureMessage: clearFailure ? null : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [status, trip, failureMessage];
}


