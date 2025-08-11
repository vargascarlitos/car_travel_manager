import 'package:sqflite/sqflite.dart' as sqflite;
import '../../app_config/database/database_helper.dart' as appdb;
import '../models/review_model.dart';

class ReviewLocalDataSource {
  ReviewLocalDataSource(this._dbHelper);

  final appdb.DatabaseHelper _dbHelper;
  static const String _table = 'reviews';

  Future<ReviewModel> createReview(ReviewModel review) async {
    try {
      await _dbHelper.insert(_table, review.toMap());
      return review;
    } on sqflite.DatabaseException catch (e) {
      throw appdb.DatabaseException('Error al crear reseña: ${e.toString()}');
    } catch (e) {
      throw appdb.DatabaseException('Error al crear reseña: $e');
    }
  }

  Future<ReviewModel?> getByTripId(String tripId) async {
    try {
      final result = await _dbHelper.query(
        _table,
        where: 'trip_id = ?',
        whereArgs: [tripId],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return ReviewModel.fromMap(result.first);
    } on sqflite.DatabaseException catch (e) {
      throw appdb.DatabaseException('Error al obtener reseña: ${e.toString()}');
    } catch (e) {
      throw appdb.DatabaseException('Error al obtener reseña: $e');
    }
  }
}


