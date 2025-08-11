import 'package:equatable/equatable.dart';
import '../../domain/entities/review.dart';

class ReviewModel extends Equatable {
  const ReviewModel({
    required this.id,
    required this.tripId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  final String id;
  final String tripId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  Review toEntity() => Review(
        id: id,
        tripId: tripId,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
      );

  factory ReviewModel.fromEntity(Review r) => ReviewModel(
        id: r.id,
        tripId: r.tripId,
        rating: r.rating,
        comment: r.comment,
        createdAt: r.createdAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        id: map['id'] as String,
        tripId: map['trip_id'] as String,
        rating: map['rating'] as int,
        comment: map['comment'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  @override
  List<Object?> get props => [id, tripId, rating, comment, createdAt];
}


