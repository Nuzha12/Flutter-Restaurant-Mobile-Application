import '../../domain/models/cart_item_model.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/address_model.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/mock_order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final MockOrderDataSource _ds;
  OrderRepositoryImpl(this._ds);

  @override Future<OrderModel>       placeOrder({required List<CartItemModel> items, required AddressModel address, required double subtotal, required double deliveryFee, required double tax, required double discount, required double total, required PaymentMethod paymentMethod, String? promoCode}) =>
      _ds.placeOrder(items: items, address: address, subtotal: subtotal, deliveryFee: deliveryFee, tax: tax, discount: discount, total: total, paymentMethod: paymentMethod, promoCode: promoCode);
  @override Future<List<OrderModel>> getOrders()              => _ds.getOrders();
  @override Future<OrderModel>       getOrderById(String id)  => _ds.getOrderById(id);
}