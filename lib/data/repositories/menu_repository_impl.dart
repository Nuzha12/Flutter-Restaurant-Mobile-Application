import '../../domain/models/category_model.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/models/review_model.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/mock_menu_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MockMenuDataSource _ds;

  MenuRepositoryImpl(this._ds);

  @override
  Future<List<CategoryModel>> getCategories() => _ds.getCategories();

  @override
  Future<List<MenuItemModel>> getMenuItems({String? categoryId, String? sortBy}) =>
      _ds.getMenuItems(categoryId: categoryId, sortBy: sortBy);

  @override
  Future<List<MenuItemModel>> searchItems(String query) => _ds.searchItems(query);

  @override
  Future<List<MenuItemModel>> getFeaturedItems() => _ds.getFeaturedItems();

  @override
  Future<List<MenuItemModel>> getNewItems() => _ds.getNewItems();

  @override
  Future<List<ReviewModel>> getReviews(String itemId) => _ds.getReviews(itemId);

  @override
  Future<void> toggleFavorite(String itemId) => _ds.toggleFavorite(itemId);
}
