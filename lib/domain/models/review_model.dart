
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String   id;
  final String   userId;
  final String   userName;
  final String?  userAvatar;
  final double   rating;
  final String   comment;
  final DateTime createdAt;
  final List<String> images;

  const ReviewModel({
    required this.id, required this.userId, required this.userName,
    this.userAvatar, required this.rating, required this.comment,
    required this.createdAt, this.images = const [],
  });

  @override
  List<Object> get props => [id, userId];
}