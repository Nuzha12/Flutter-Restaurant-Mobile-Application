import 'package:equatable/equatable.dart';
import 'cart_item_model.dart';
import 'address_model.dart';

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }
enum PaymentMethod { card, cash, wallet, upi }

class OrderModel extends Equatable {
  final String          id;
  final List<CartItemModel> items;
  final OrderStatus     status;
  final DateTime        createdAt;
  final AddressModel    deliveryAddress;
  final double          subtotal;
  final double          deliveryFee;
  final double          tax;
  final double          discount;
  final double          total;
  final int             estimatedMinutes;
  final PaymentMethod   paymentMethod;
  final String?         promoCode;
  final int             loyaltyEarned;

  const OrderModel({
    required this.id,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    this.discount     = 0,
    required this.total,
    required this.estimatedMinutes,
    this.paymentMethod = PaymentMethod.card,
    this.promoCode,
    this.loyaltyEarned = 0,
  });

  String get statusLabel {
    const map = {
      OrderStatus.pending:         'Pending',
      OrderStatus.confirmed:       'Confirmed',
      OrderStatus.preparing:       'Preparing',
      OrderStatus.outForDelivery:  'Out for Delivery',
      OrderStatus.delivered:       'Delivered',
      OrderStatus.cancelled:       'Cancelled',
    };
    return map[status]!;
  }

  bool get isActive => status != OrderStatus.delivered && status != OrderStatus.cancelled;

  OrderModel copyWith({OrderStatus? status}) => OrderModel(
    id: id, items: items, createdAt: createdAt, deliveryAddress: deliveryAddress,
    subtotal: subtotal, deliveryFee: deliveryFee, tax: tax, discount: discount,
    total: total, estimatedMinutes: estimatedMinutes, paymentMethod: paymentMethod,
    promoCode: promoCode, loyaltyEarned: loyaltyEarned,
    status: status ?? this.status,
  );

  @override
  List<Object> get props => [id, status];
}