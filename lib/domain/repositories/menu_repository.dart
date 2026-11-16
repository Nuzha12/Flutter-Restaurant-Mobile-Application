import '../models/category_model.dart';
import '../models/menu_item_model.dart';
import '../models/review_model.dart';
abstract class MenuRepository {
  Future<List<CategoryModel>>  getCategories();
  Future<List<MenuItemModel>>  getMenuItems({String? categoryId, String? sortBy});
  Future<List<MenuItemModel>>  searchItems(String query);
  Future<List<MenuItemModel>>  getFeaturedItems();
  Future<List<MenuItemModel>>  getNewItems();
  Future<List<ReviewModel>>    getReviews(String itemId);
  Future<void>                 toggleFavorite(String itemId);
}