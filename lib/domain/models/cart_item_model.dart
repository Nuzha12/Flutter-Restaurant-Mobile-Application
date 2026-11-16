import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

class CartItemModel extends Equatable {
  final MenuItemModel menuItem;
  final int           quantity;
  final String?       specialInstructions;

  const CartItemModel({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  double get subtotal => menuItem.effectivePrice * quantity;
  int    get points   => menuItem.loyaltyPoints * quantity;

  CartItemModel copyWith({int? quantity, String? specialInstructions}) => CartItemModel(
    menuItem: menuItem,
    quantity:             quantity             ?? this.quantity,
    specialInstructions:  specialInstructions  ?? this.specialInstructions,
  );

  @override
  List<Object> get props => [menuItem.id, quantity];
}