import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/providers.dart';
import 'package:hamster_pos_frontend/features/admin/repository/admin_repository.dart';
import 'package:hamster_pos_frontend/features/products/models/product_model.dart';
import 'package:hamster_pos_frontend/features/order/models/order_model.dart';

final adminRepositoryProvider = Provider.autoDispose<AdminRepository>((ref) {
  return AdminRepository(ref.watch(apiClientProvider));
});


final lowStockProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.watch(adminRepositoryProvider).getLowStockProducts();
});

final allOrdersProvider = FutureProvider.autoDispose<List<OrderResponse>>((ref) {
  return ref.watch(adminRepositoryProvider).getAllOrders();
});

class AddProductState {
  final bool isLoading;
  final String? error;
  AddProductState({this.isLoading = false, this.error});
}

class AddProductController extends StateNotifier<AddProductState> {
  final AdminRepository _adminRepository;
  AddProductController(this._adminRepository) : super(AddProductState());

  Future<bool> addProduct(String name, String price, String stock) async {
    state = AddProductState(isLoading: true);
    try {
      final priceDouble = double.parse(price);
      final stockInt = int.parse(stock);
      await _adminRepository.addProduct(name, priceDouble, stockInt);
      state = AddProductState(isLoading: false);
      return true;
    } catch (e) {
      state = AddProductState(isLoading: false, error: 'Failed: ${e.toString()}');
      return false;
    }
  }
}

final addProductControllerProvider =
    StateNotifierProvider.autoDispose<AddProductController, AddProductState>(
        (ref) => AddProductController(ref.watch(adminRepositoryProvider)));