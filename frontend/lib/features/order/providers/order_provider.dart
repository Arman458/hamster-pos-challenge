import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/providers.dart';
import 'package:hamster_pos_frontend/features/cart/models/cart_model.dart';
import 'package:hamster_pos_frontend/features/order/models/order_model.dart';
import 'package:hamster_pos_frontend/features/order/repository/order_repository.dart';
class OrderState {
  final bool isLoading;
  final String? error;
  OrderState({this.isLoading = false, this.error});
}

class OrderController extends StateNotifier<OrderState> {
  final OrderRepository _orderRepository;
  OrderController(this._orderRepository) : super(OrderState());

  Future<bool> placeOrder(Cart cart) async {
    final items = cart.items
        .map((cartItem) => OrderItemRequest(
              productId: cartItem.product.id,
              quantity: cartItem.quantity,
            ))
        .toList();

    if (items.isEmpty) {
      state = OrderState(error: "Cannot place an empty order.");
      return false;
    }

    state = OrderState(isLoading: true);
    try {
      final request = OrderRequest(items: items);
      await _orderRepository.placeOrder(request);
      state = OrderState(isLoading: false);
      return true;
    } catch (e) {
      state = OrderState(
          isLoading: false, error: "Order failed: ${e.toString()}");
      return false;
    }
  }
}

// Repository Provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(apiClientProvider));
});

// Controller Provider
final orderControllerProvider =
    StateNotifierProvider.autoDispose<OrderController, OrderState>((ref) {
  return OrderController(ref.watch(orderRepositoryProvider));
});


final myOrdersProvider = FutureProvider.autoDispose<List<OrderResponse>>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getMyOrders();
});