import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_local_datasource.dart';
import '../models/review_model.dart';
import '../../app_config/database/database_helper.dart' as appdb;

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(appdb.DatabaseHelper dbHelper)
      : _local = ReviewLocalDataSource(dbHelper);

  final ReviewLocalDataSource _local;

  @override
  Future<Review> createReview(Review review) async {
    try {
      final model = ReviewModel.fromEntity(review);
      final saved = await _local.createReview(model);
      return saved.toEntity();
    } on appdb.DatabaseException {
      rethrow;
    } catch (e) {
      throw appdb.DatabaseException('Failed to create review: $e');
    }
  }

  @override
  Future<Review?> getByTripId(String tripId) async {
    try {
      final model = await _local.getByTripId(tripId);
      return model?.toEntity();
    } on appdb.DatabaseException {
      rethrow;
    } catch (e) {
      throw appdb.DatabaseException('Failed to get review: $e');
    }
  }
}


