import '../../domain/models/cart_item_model.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/address_model.dart';

class MockOrderDataSource {
  final List<OrderModel> _orders = [];

  static final List<AddressModel> sampleAddresses = [
    const AddressModel(id: 'addr_1', label: 'Home',   type: AddressType.home,  street: '123 Main Street, Apt 4B', city: 'New York',  state: 'NY', zip: '10001', isDefault: true),
    const AddressModel(id: 'addr_2', label: 'Office', type: AddressType.work,  street: '456 Park Avenue, Floor 12', city: 'New York', state: 'NY', zip: '10022'),
    const AddressModel(id: 'addr_3', label: 'Mom\'s', type: AddressType.other, street: '789 Oak Drive',            city: 'Brooklyn',  state: 'NY', zip: '11201'),
  ];

  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required AddressModel        address,
    required double              subtotal,
    required double              deliveryFee,
    required double              tax,
    required double              discount,
    required double              total,
    required PaymentMethod       paymentMethod,
    String?                      promoCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final earned = items.fold(0, (s, ci) => s + ci.points);
    final order = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      items: items, status: OrderStatus.confirmed, createdAt: DateTime.now(),
      deliveryAddress: address, subtotal: subtotal, deliveryFee: deliveryFee,
      tax: tax, discount: discount, total: total, estimatedMinutes: 30 + (items.length * 2),
      paymentMethod: paymentMethod, promoCode: promoCode, loyaltyEarned: earned,
    );
    _orders.insert(0, order);
    return order;
  }

  Future<List<OrderModel>> getOrders()              async { await Future.delayed(const Duration(milliseconds: 300)); return List.from(_orders); }
  Future<OrderModel>       getOrderById(String id)  async => _orders.firstWhere((o) => o.id == id);
}