import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/cart_repository_impl.dart';
import '../../../domain/models/menu_item_model.dart';
import 'cart_state.dart';

final _cartRepo = Provider((_) => CartRepositoryImpl());

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
        (ref) => CartNotifier(ref.read(_cartRepo)));

const Map<String, double> _promoCodes = {
  'WELCOME30': 0.30,
  'FREEDEL':   0.00,
  'SAVE10':    0.10,
  'BOGO':      0.15,
};

class CartNotifier extends StateNotifier<CartState> {
  final CartRepositoryImpl _repo;
  CartNotifier(this._repo) : super(const CartState());

  void addItem(MenuItemModel item, {int quantity = 1, String? instructions}) {
    _repo.addItem(item, quantity: quantity, instructions: instructions);
    state = state.copyWith(items: List.from(_repo.getCartItems()));
  }

  void removeItem(String id) {
    _repo.removeItem(id);
    state = state.copyWith(items: List.from(_repo.getCartItems()));
  }

  void updateQuantity(String id, int qty) {
    _repo.updateQuantity(id, qty);
    state = state.copyWith(items: List.from(_repo.getCartItems()));
  }

  void updateInstructions(String id, String instructions) {
    _repo.updateInstructions(id, instructions);
    state = state.copyWith(items: List.from(_repo.getCartItems()));
  }

  void clearCart() {
    _repo.clearCart();
    state = const CartState();
  }

  String? applyPromo(String code) {
    final key = code.trim().toUpperCase();
    if (!_promoCodes.containsKey(key)) return 'Invalid promo code';
    final pct = _promoCodes[key]!;
    final disc = state.subtotal * pct;
    state = state.copyWith(promoCode: key, promoDiscount: disc);
    return null;
  }

  void removePromo() => state = state.clearPromo();
}