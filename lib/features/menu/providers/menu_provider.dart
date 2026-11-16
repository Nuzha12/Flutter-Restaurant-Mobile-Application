import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/mock_menu_datasource.dart';
import '../../../data/repositories/menu_repository_impl.dart';
import '../../../domain/models/category_model.dart';
import '../../../domain/models/menu_item_model.dart';
import '../../../domain/models/review_model.dart';

final _menuDs   = Provider((_) => MockMenuDataSource());
final _menuRepo = Provider((ref) => MenuRepositoryImpl(ref.read(_menuDs)));

final categoriesProvider       = FutureProvider<List<CategoryModel>>(
        (ref) => ref.read(_menuRepo).getCategories());

final selectedCategoryProvider = StateProvider<String?>((_) => null);
final selectedSortProvider     = StateProvider<String>((_)  => 'Popular');

final menuItemsProvider = FutureProvider<List<MenuItemModel>>((ref) {
  final cat  = ref.watch(selectedCategoryProvider);
  final sort = ref.watch(selectedSortProvider);
  return ref.read(_menuRepo).getMenuItems(categoryId: cat, sortBy: sort);
});

final featuredItemsProvider = FutureProvider<List<MenuItemModel>>(
        (ref) => ref.read(_menuRepo).getFeaturedItems());

final newItemsProvider = FutureProvider<List<MenuItemModel>>(
        (ref) => ref.read(_menuRepo).getNewItems());

final searchQueryProvider   = StateProvider<String>((_) => '');
final searchResultsProvider = FutureProvider<List<MenuItemModel>>((ref) {
  final q = ref.watch(searchQueryProvider);
  if (q.trim().isEmpty) return Future.value([]);
  return ref.read(_menuRepo).searchItems(q);
});

final itemReviewsProvider =
FutureProvider.family<List<ReviewModel>, String>(
        (ref, id) => ref.read(_menuRepo).getReviews(id));

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, Set<String>>(
        (ref) => FavoritesNotifier(ref));

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final Ref _ref;

  FavoritesNotifier(this._ref) : super({});

  Future<void> toggle(String id) async {
    await _ref.read(_menuRepo).toggleFavorite(id);
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
    _ref.invalidate(menuItemsProvider);
    _ref.invalidate(featuredItemsProvider);
    _ref.invalidate(newItemsProvider);
    _ref.invalidate(searchResultsProvider);
  }

  bool isFav(String id) => state.contains(id);
}