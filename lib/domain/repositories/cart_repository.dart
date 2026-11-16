import '../models/cart_item_model.dart';
import '../models/menu_item_model.dart';
abstract class CartRepository {
  List<CartItemModel> getCartItems();
  void addItem(MenuItemModel item, {int quantity, String? instructions});
  void removeItem(String menuItemId);
  void updateQuantity(String menuItemId, int quantity);
  void updateInstructions(String menuItemId, String instructions);
  void clearCart();
  double getSubtotal();
}