import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/repositories/review_repository.dart';

enum ReviewStatus { initial, loading, success, failure }

class ReviewState {
  const ReviewState({
    this.status = ReviewStatus.initial,
    this.rating = 0,
    this.comment = '',
    this.failureMessage,
  });

  final ReviewStatus status;
  final int rating;
  final String comment;
  final String? failureMessage;

  ReviewState copyWith({
    ReviewStatus? status,
    int? rating,
    String? comment,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return ReviewState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      failureMessage: clearFailure ? null : (failureMessage ?? this.failureMessage),
    );
  }
}

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit({required ReviewRepository repository, required String tripId})
      : _repository = repository,
        _tripId = tripId,
        super(const ReviewState());

  final ReviewRepository _repository;
  final String _tripId;

  void ratingChanged(int value) => emit(state.copyWith(rating: value, clearFailure: true));
  void commentChanged(String value) {
    final truncated = value.length > 1000 ? value.substring(0, 1000) : value;
    emit(state.copyWith(comment: truncated, clearFailure: true));
  }

  Future<void> save() async {
    if (state.rating < 1) return;
    emit(state.copyWith(status: ReviewStatus.loading, clearFailure: true));
    try {
      final review = Review(
        id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
        tripId: _tripId,
        rating: state.rating,
        comment: state.comment.isEmpty ? null : state.comment,
        createdAt: DateTime.now(),
      );
      await _repository.createReview(review);
      emit(state.copyWith(status: ReviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ReviewStatus.failure, failureMessage: 'No se pudo guardar la reseña'));
    }
  }
}


