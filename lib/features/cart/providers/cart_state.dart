import 'package:equatable/equatable.dart';
import '../../../domain/models/cart_item_model.dart';
import '../../../core/constants/app_constants.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final String?             promoCode;
  final double              promoDiscount;

  const CartState({this.items = const [], this.promoCode, this.promoDiscount = 0});

  int    get itemCount    => items.fold(0, (s, ci) => s + ci.quantity);
  double get subtotal     => items.fold(0.0, (s, ci) => s + ci.subtotal);
  double get deliveryFee  => subtotal >= AppConstants.freeDeliveryThreshold ? 0 : AppConstants.deliveryFee;
  double get tax          => subtotal * AppConstants.taxRate;
  double get discount     => promoDiscount;
  double get total        => (subtotal + deliveryFee + tax - discount).clamp(0, double.infinity);
  int    get totalPoints  => items.fold(0, (s, ci) => s + ci.points);
  bool   get isEmpty      => items.isEmpty;
  bool   get hasPromo     => promoCode != null;

  CartState copyWith({List<CartItemModel>? items, String? promoCode, double? promoDiscount}) =>
      CartState(
        items:         items         ?? this.items,
        promoCode:     promoCode     ?? this.promoCode,
        promoDiscount: promoDiscount ?? this.promoDiscount,
      );

  CartState clearPromo() => CartState(items: items);

  @override
  List<Object?> get props => [items, promoCode, promoDiscount];
}