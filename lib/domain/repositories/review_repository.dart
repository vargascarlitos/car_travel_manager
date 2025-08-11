import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Review> createReview(Review review);
  Future<Review?> getByTripId(String tripId);
}


