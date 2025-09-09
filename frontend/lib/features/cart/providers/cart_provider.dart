import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/features/cart/models/cart_model.dart';
import 'package:hamster_pos_frontend/features/products/models/product_model.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier()
      : super(Cart(items: [], subtotal: 0, tax: 0, total: 0));

  Future<bool> addProduct(Product product) async {
    final existingItemIndex =
        state.items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      final item = state.items[existingItemIndex];
      if (item.quantity < product.stock) {
        item.quantity++;
        _recalculateTotals();
        return true;
      } else {
        return false;
      }
    } else {
      if (product.stock > 0) {
        state.items.add(CartItem(product: product));
        _recalculateTotals();
        return true;
      } else {
        return false;
      }
    }
}

  void removeProduct(int productId) {
    state.items.removeWhere((item) => item.product.id == productId);
    _recalculateTotals();
  }

  void clearCart() {
    state = Cart(items: [], subtotal: 0, tax: 0, total: 0);
  }

  void _recalculateTotals() {
    double subtotal = 0;
    for (var item in state.items) {
      subtotal += item.product.price * item.quantity;
    }
    double tax = subtotal * 0.10;
    double total = subtotal + tax;

    state = Cart(
      items: List.from(state.items),
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});