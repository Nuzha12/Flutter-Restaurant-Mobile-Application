import '../../domain/models/cart_item_model.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemModel> _items = [];

  @override List<CartItemModel> getCartItems() => List.unmodifiable(_items);

  @override
  void addItem(MenuItemModel item, {int quantity = 1, String? instructions}) {
    final idx = _items.indexWhere((ci) => ci.menuItem.id == item.id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + quantity);
    } else {
      _items.add(CartItemModel(menuItem: item, quantity: quantity, specialInstructions: instructions));
    }
  }

  @override void removeItem(String id)        => _items.removeWhere((ci) => ci.menuItem.id == id);
  @override void clearCart()                  => _items.clear();
  @override double getSubtotal()              => _items.fold(0.0, (s, ci) => s + ci.subtotal);

  @override
  void updateQuantity(String id, int qty) {
    if (qty <= 0) { removeItem(id); return; }
    final idx = _items.indexWhere((ci) => ci.menuItem.id == id);
    if (idx >= 0) _items[idx] = _items[idx].copyWith(quantity: qty);
  }

  @override
  void updateInstructions(String id, String instructions) {
    final idx = _items.indexWhere((ci) => ci.menuItem.id == id);
    if (idx >= 0) _items[idx] = _items[idx].copyWith(specialInstructions: instructions);
  }
}