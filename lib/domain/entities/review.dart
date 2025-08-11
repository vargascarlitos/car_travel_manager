import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.tripId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  final String id;
  final String tripId;
  final int rating; // 1-5
  final String? comment; // <= 1000 chars
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, tripId, rating, comment, createdAt];
}


