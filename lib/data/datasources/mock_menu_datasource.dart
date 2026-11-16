import '../../domain/models/category_model.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/models/review_model.dart';

class MockMenuDataSource {
  static final List<CategoryModel> _cats = [
    const CategoryModel(id: 'cat_1', name: 'Burgers',  emoji: '🍔', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80', itemCount: 5),
    const CategoryModel(id: 'cat_2', name: 'Pizza',    emoji: '🍕', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80', itemCount: 5),
    const CategoryModel(id: 'cat_3', name: 'Sushi',    emoji: '🍣', imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80', itemCount: 4),
    const CategoryModel(id: 'cat_4', name: 'Pasta',    emoji: '🍝', imageUrl: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400&q=80', itemCount: 4),
    const CategoryModel(id: 'cat_5', name: 'Salads',   emoji: '🥗', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80', itemCount: 3),
    const CategoryModel(id: 'cat_6', name: 'Desserts', emoji: '🍰', imageUrl: 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&q=80', itemCount: 4),
    const CategoryModel(id: 'cat_7', name: 'Drinks',   emoji: '🥤', imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&q=80', itemCount: 3),
    const CategoryModel(id: 'cat_8', name: 'Wraps',    emoji: '🌯', imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&q=80', itemCount: 3),
  ];

  static final List<MenuItemModel> _items = [
    const MenuItemModel(id: 'item_1',  name: 'Classic Smash Burger',    description: 'Double smashed beef patty, American cheese, caramelized onions, pickles, and our secret sauce on a brioche bun.',   price: 14.99,  imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700&q=85',  categoryId: 'cat_1', rating: 4.8, reviewCount: 324, prepTimeMinutes: 15, tags: [DietaryTag.bestseller], ingredients: ['Beef patty', 'Brioche bun', 'American cheese', 'Pickles', 'Secret sauce'], calories: 720, loyaltyPoints: 15),
    const MenuItemModel(id: 'item_2',  name: 'BBQ Bacon Burger',         description: 'Juicy beef patty, crispy bacon, cheddar, BBQ sauce, and crispy onion rings.',                                        price: 16.99,  imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=700&q=85',  categoryId: 'cat_1', rating: 4.6, reviewCount: 218, prepTimeMinutes: 18, tags: [DietaryTag.spicy], ingredients: ['Beef patty', 'Bacon', 'Cheddar', 'BBQ sauce', 'Onion rings'], calories: 890, loyaltyPoints: 17),
    const MenuItemModel(id: 'item_3',  name: 'Mushroom Swiss Burger',    description: 'Sautéed mushrooms, melted Swiss cheese, garlic aioli on a pretzel bun.',                                            price: 15.49, discountedPrice: 12.99, imageUrl: 'https://images.unsplash.com/photo-1586816001966-79b736744398?w=700&q=85',  categoryId: 'cat_1', rating: 4.5, reviewCount: 167, prepTimeMinutes: 16, tags: [], ingredients: ['Beef patty', 'Mushrooms', 'Swiss cheese', 'Garlic aioli'], calories: 680, loyaltyPoints: 13),
    const MenuItemModel(id: 'item_4',  name: 'Crispy Chicken Burger',    description: 'Crunchy fried chicken breast, coleslaw, pickles, and chipotle mayo.',                                                price: 13.99,  imageUrl: 'https://images.unsplash.com/photo-1562802378-063ec186a863?w=700&q=85',  categoryId: 'cat_1', rating: 4.4, reviewCount: 189, prepTimeMinutes: 14, tags: [DietaryTag.new_], ingredients: ['Chicken breast', 'Coleslaw', 'Pickles', 'Chipotle mayo'], calories: 640, loyaltyPoints: 14),
    const MenuItemModel(id: 'item_5',  name: 'Vegan Impossible Burger',  description: 'Plant-based patty with vegan cheese, avocado, and sriracha aioli.',                                                  price: 15.99,  imageUrl: 'https://images.unsplash.com/photo-1614531341773-3bff8b7cb3fc?w=700&q=85',  categoryId: 'cat_1', rating: 4.3, reviewCount: 98,  prepTimeMinutes: 13, tags: [DietaryTag.vegan, DietaryTag.glutenFree], ingredients: ['Impossible patty', 'Vegan cheese', 'Avocado', 'Sriracha aioli'], calories: 520, loyaltyPoints: 16),
    const MenuItemModel(id: 'item_6',  name: 'Margherita Pizza',         description: 'San Marzano tomatoes, fresh mozzarella, and fragrant basil on a hand-stretched Neapolitan crust.',                   price: 13.99,  imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=700&q=85',  categoryId: 'cat_2', rating: 4.7, reviewCount: 289, prepTimeMinutes: 20, tags: [DietaryTag.vegetarian, DietaryTag.bestseller], ingredients: ['San Marzano tomatoes', 'Fresh mozzarella', 'Basil', 'Olive oil'], calories: 580, loyaltyPoints: 14),
    const MenuItemModel(id: 'item_7',  name: 'Pepperoni Feast',          description: 'Premium pepperoni, three-cheese blend, and a rich house tomato sauce.',                                              price: 15.99,  imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=700&q=85',  categoryId: 'cat_2', rating: 4.9, reviewCount: 412, prepTimeMinutes: 22, tags: [DietaryTag.bestseller], ingredients: ['Pepperoni', 'Mozzarella', 'Tomato sauce', 'Oregano'], calories: 760, loyaltyPoints: 16),
    const MenuItemModel(id: 'item_8',  name: 'Truffle Mushroom Pizza',   description: 'White base with wild mushrooms, truffle oil, arugula, and shaved Parmesan.',                                        price: 18.99, discountedPrice: 15.99, imageUrl: 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?w=700&q=85',  categoryId: 'cat_2', rating: 4.6, reviewCount: 143, prepTimeMinutes: 24, tags: [DietaryTag.vegetarian, DietaryTag.chefSpecial], ingredients: ['Wild mushrooms', 'Truffle oil', 'Arugula', 'Parmesan'], calories: 620, loyaltyPoints: 19),
    const MenuItemModel(id: 'item_9',  name: 'BBQ Chicken Pizza',        description: 'Smoked chicken, caramelized onions, BBQ sauce, and mozzarella.',                                                     price: 16.49,  imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=700&q=85',  categoryId: 'cat_2', rating: 4.5, reviewCount: 201, prepTimeMinutes: 21, tags: [], ingredients: ['Smoked chicken', 'Caramelized onions', 'BBQ sauce', 'Mozzarella'], calories: 680, loyaltyPoints: 16),
    const MenuItemModel(id: 'item_10', name: 'Salmon Nigiri (6 pcs)',    description: 'Premium Atlantic salmon over hand-pressed sushi rice, with wasabi and pickled ginger.',                              price: 16.99,  imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=700&q=85',  categoryId: 'cat_3', rating: 4.8, reviewCount: 198, prepTimeMinutes: 12, tags: [DietaryTag.glutenFree], ingredients: ['Atlantic salmon', 'Sushi rice', 'Wasabi', 'Pickled ginger'], calories: 320, loyaltyPoints: 17),
    const MenuItemModel(id: 'item_11', name: 'Dragon Roll (8 pcs)',       description: 'Shrimp tempura and cucumber inside, topped with avocado, spicy mayo, and eel sauce.',                               price: 18.49,  imageUrl: 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=700&q=85',  categoryId: 'cat_3', rating: 4.7, reviewCount: 256, prepTimeMinutes: 15, tags: [DietaryTag.bestseller, DietaryTag.spicy], ingredients: ['Shrimp tempura', 'Cucumber', 'Avocado', 'Spicy mayo'], calories: 480, loyaltyPoints: 18),
    const MenuItemModel(id: 'item_12', name: 'Spaghetti Carbonara',      description: 'Al dente spaghetti in silky eggs, Pecorino Romano, guanciale, and cracked black pepper.',                           price: 17.99,  imageUrl: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=700&q=85',  categoryId: 'cat_4', rating: 4.8, reviewCount: 334, prepTimeMinutes: 18, tags: [DietaryTag.bestseller, DietaryTag.chefSpecial], ingredients: ['Spaghetti', 'Eggs', 'Pecorino Romano', 'Guanciale', 'Black pepper'], calories: 720, loyaltyPoints: 18),
    const MenuItemModel(id: 'item_13', name: 'Penne Arrabbiata',         description: 'Penne in a fiery tomato sauce with garlic, chili flakes, and fresh parsley. Vegan.',                                price: 14.99,  imageUrl: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=700&q=85',  categoryId: 'cat_4', rating: 4.5, reviewCount: 178, prepTimeMinutes: 15, tags: [DietaryTag.vegan, DietaryTag.spicy], ingredients: ['Penne', 'San Marzano tomatoes', 'Garlic', 'Chili flakes'], calories: 560, loyaltyPoints: 15),
    const MenuItemModel(id: 'item_14', name: 'Caesar Salad',             description: 'Crisp romaine, shaved Parmesan, house croutons, and classic Caesar dressing.',                                      price: 11.99,  imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700&q=85',  categoryId: 'cat_5', rating: 4.4, reviewCount: 142, prepTimeMinutes: 8,  tags: [DietaryTag.vegetarian], ingredients: ['Romaine', 'Parmesan', 'Croutons', 'Caesar dressing'], calories: 380, loyaltyPoints: 12),
    const MenuItemModel(id: 'item_15', name: 'New York Cheesecake',      description: 'Creamy dense cheesecake on a graham cracker crust, topped with fresh strawberry compote.',                          price: 8.99,   imageUrl: 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=700&q=85',  categoryId: 'cat_6', rating: 4.9, reviewCount: 521, prepTimeMinutes: 5,  tags: [DietaryTag.vegetarian, DietaryTag.bestseller], ingredients: ['Cream cheese', 'Graham cracker crust', 'Strawberry compote'], calories: 490, loyaltyPoints: 9),
    const MenuItemModel(id: 'item_16', name: 'Chocolate Lava Cake',      description: 'Warm chocolate cake with a molten center, served with vanilla ice cream.',                                          price: 9.49,   imageUrl: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=700&q=85',  categoryId: 'cat_6', rating: 4.8, reviewCount: 398, prepTimeMinutes: 12, tags: [DietaryTag.vegetarian, DietaryTag.new_], ingredients: ['Dark chocolate', 'Butter', 'Eggs', 'Flour'], calories: 560, loyaltyPoints: 9),
    const MenuItemModel(id: 'item_17', name: 'Mango Lassi',              description: 'Refreshing yogurt drink blended with Alphonso mango, honey, and cardamom.',                                        price: 5.99,   imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=700&q=85',  categoryId: 'cat_7', rating: 4.6, reviewCount: 189, prepTimeMinutes: 3,  tags: [DietaryTag.vegetarian, DietaryTag.glutenFree], ingredients: ['Mango', 'Yogurt', 'Honey', 'Cardamom'], calories: 220, loyaltyPoints: 6),
    const MenuItemModel(id: 'item_18', name: 'Spicy Chicken Wrap',       description: 'Grilled spicy chicken, avocado, shredded lettuce, pico de gallo in a warm tortilla.',                              price: 12.49,  imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=700&q=85',  categoryId: 'cat_8', rating: 4.5, reviewCount: 165, prepTimeMinutes: 10, tags: [DietaryTag.spicy], ingredients: ['Chicken', 'Avocado', 'Lettuce', 'Pico de gallo', 'Tortilla'], calories: 520, loyaltyPoints: 12),
  ];

  static final List<ReviewModel> _reviews = [
    ReviewModel(id: 'rev_1', userId: 'usr_2', userName: 'Sarah M.', userAvatar: 'https://i.pravatar.cc/60?img=5',  rating: 5.0, comment: 'Absolutely the best burger in the city. That smash technique gives incredible crust!',     createdAt: DateTime(2025, 3, 10)),
    ReviewModel(id: 'rev_2', userId: 'usr_3', userName: 'James K.', userAvatar: 'https://i.pravatar.cc/60?img=8',  rating: 4.5, comment: 'Great flavours and blazing fast delivery. Arrived piping hot. Will definitely reorder.',    createdAt: DateTime(2025, 2, 28)),
    ReviewModel(id: 'rev_3', userId: 'usr_4', userName: 'Priya N.', userAvatar: 'https://i.pravatar.cc/60?img=15', rating: 4.0, comment: 'Solid food, well-packaged, and the cheesecake was absolutely phenomenal.',                   createdAt: DateTime(2025, 1, 20)),
    ReviewModel(id: 'rev_4', userId: 'usr_5', userName: 'Tom R.',   userAvatar: 'https://i.pravatar.cc/60?img=22', rating: 5.0, comment: 'Ordered for the whole office. Everyone was delighted. The carbonara is otherworldly.',       createdAt: DateTime(2025, 4, 5)),
  ];

  final Set<String> _favorites = {};

  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _cats;
  }

  Future<List<MenuItemModel>> getMenuItems({String? categoryId, String? sortBy}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var list = categoryId == null ? _items : _items.where((i) => i.categoryId == categoryId).toList();
    switch (sortBy) {
      case 'Price: Low to High': list.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
      case 'Price: High to Low': list.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
      case 'Rating':             list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'Prep Time':          list.sort((a, b) => a.prepTimeMinutes.compareTo(b.prepTimeMinutes));
      default:                   list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    return list.map((i) => i.copyWith(isFavorite: _favorites.contains(i.id))).toList();
  }

  Future<List<MenuItemModel>> searchItems(String q) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final lq = q.toLowerCase();
    return _items.where((i) =>
    i.name.toLowerCase().contains(lq) ||
        i.description.toLowerCase().contains(lq) ||
        i.ingredients.any((ing) => ing.toLowerCase().contains(lq))).toList();
  }

  Future<List<MenuItemModel>> getFeaturedItems() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _items.where((i) => i.tags.contains(DietaryTag.bestseller)).toList();
  }

  Future<List<MenuItemModel>> getNewItems() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _items.where((i) => i.tags.contains(DietaryTag.new_)).toList();
  }

  Future<List<ReviewModel>> getReviews(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _reviews;
  }

  Future<void> toggleFavorite(String itemId) async {
    if (_favorites.contains(itemId)) { _favorites.remove(itemId); }
    else { _favorites.add(itemId); }
  }

  bool isFavorite(String itemId) => _favorites.contains(itemId);
}