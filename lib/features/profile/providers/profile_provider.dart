import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/mock_order_datasource.dart';
import '../../../domain/models/address_model.dart';

final profileAddressesProvider = StateNotifierProvider<AddressNotifier, List<AddressModel>>(
        (_) => AddressNotifier(MockOrderDataSource.sampleAddresses));

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier(super.init);

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }

  void add(AddressModel addr) => state = [...state, addr];

  void remove(String id) => state = state.where((a) => a.id != id).toList();
}