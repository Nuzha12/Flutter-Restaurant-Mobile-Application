import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';
abstract class OrderRepository {
  Future<OrderModel>       placeOrder({required List<CartItemModel> items, required AddressModel address, required double subtotal, required double deliveryFee, required double tax, required double discount, required double total, required PaymentMethod paymentMethod, String? promoCode});
  Future<List<OrderModel>> getOrders();
  Future<OrderModel>       getOrderById(String id);
}