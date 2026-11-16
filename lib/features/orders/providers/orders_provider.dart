import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/mock_order_datasource.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/models/address_model.dart';
import '../../../domain/models/cart_item_model.dart';
import '../../../domain/models/order_model.dart';

final _orderDs   = Provider((_) => MockOrderDataSource());
final _orderRepo = Provider((ref) => OrderRepositoryImpl(ref.read(_orderDs)));

final ordersProvider = StateNotifierProvider<OrdersNotifier, AsyncValue<List<OrderModel>>>(
        (ref) => OrdersNotifier(ref.read(_orderRepo)));

final selectedAddressProvider  = StateProvider<AddressModel>((ref) => MockOrderDataSource.sampleAddresses.first);
final savedAddressesProvider   = Provider<List<AddressModel>>((ref) => MockOrderDataSource.sampleAddresses);
final selectedPaymentProvider  = StateProvider<PaymentMethod>((ref) => PaymentMethod.card);

class OrdersNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderRepositoryImpl _repo;
  OrdersNotifier(this._repo) : super(const AsyncValue.loading()) { loadOrders(); }

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    try { state = AsyncValue.data(await _repo.getOrders()); }
    catch (e, st) { state = AsyncValue.error(e, st); }
  }

  Future<OrderModel?> placeOrder({
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
    try {
      final order = await _repo.placeOrder(
        items: items, address: address, subtotal: subtotal,
        deliveryFee: deliveryFee, tax: tax, discount: discount,
        total: total, paymentMethod: paymentMethod, promoCode: promoCode,
      );
      final cur = state.valueOrNull ?? [];
      state = AsyncValue.data([order, ...cur]);
      return order;
    } catch (_) { return null; }
  }
}