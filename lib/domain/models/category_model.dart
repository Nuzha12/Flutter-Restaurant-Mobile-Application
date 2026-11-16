import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final String imageUrl;
  final int    itemCount;

  const CategoryModel({
    required this.id, required this.name,
    required this.emoji, required this.imageUrl,
    this.itemCount = 0,
  });

  @override
  List<Object> get props => [id, name];
}