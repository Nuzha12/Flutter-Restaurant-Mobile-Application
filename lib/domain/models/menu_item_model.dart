import 'package:equatable/equatable.dart';

enum DietaryTag { vegetarian, vegan, glutenFree, spicy, bestseller, new_, chefSpecial }

class MenuItemModel extends Equatable {
  final String          id;
  final String          name;
  final String          description;
  final double          price;
  final double?         discountedPrice;
  final String          imageUrl;
  final String          categoryId;
  final double          rating;
  final int             reviewCount;
  final int             prepTimeMinutes;
  final List<DietaryTag> tags;
  final bool            isAvailable;
  final bool            isFavorite;
  final List<String>    ingredients;
  final int             calories;
  final int             loyaltyPoints;
  final List<String>    allergens;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.imageUrl,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    this.tags         = const [],
    this.isAvailable  = true,
    this.isFavorite   = false,
    this.ingredients  = const [],
    this.calories     = 0,
    this.loyaltyPoints = 10,
    this.allergens    = const [],
  });

  double get effectivePrice => discountedPrice ?? price;
  bool   get hasDiscount    => discountedPrice != null && discountedPrice! < price;
  double get discountPct    => hasDiscount ? ((price - discountedPrice!) / price * 100).roundToDouble() : 0;

  MenuItemModel copyWith({bool? isFavorite}) => MenuItemModel(
    id: id, name: name, description: description, price: price,
    discountedPrice: discountedPrice, imageUrl: imageUrl, categoryId: categoryId,
    rating: rating, reviewCount: reviewCount, prepTimeMinutes: prepTimeMinutes,
    tags: tags, isAvailable: isAvailable, ingredients: ingredients,
    calories: calories, loyaltyPoints: loyaltyPoints, allergens: allergens,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  @override
  List<Object> get props => [id, name, price, isFavorite];
}