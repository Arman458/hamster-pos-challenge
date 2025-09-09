import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/widgets/main_app_bar.dart';
import 'package:hamster_pos_frontend/features/cart/providers/cart_provider.dart';
import 'package:hamster_pos_frontend/features/order/providers/order_provider.dart';

class CartScreen extends ConsumerWidget {
  static const route = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final orderState = ref.watch(orderControllerProvider);

    ref.listen<OrderState>(orderControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    void handlePlaceOrder() async {
      final success =
          await ref.read(orderControllerProvider.notifier).placeOrder(cart);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        ref.read(cartProvider.notifier).clearCart();
      }
    }

    return Scaffold(
      appBar: const MainAppBar(title: 'My Cart'),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: const Icon(Icons.image_outlined),
                        title: Text(item.product.name),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTotalRow('Subtotal:',
                          '\$${cart.subtotal.toStringAsFixed(2)}'),
                      _buildTotalRow('Tax (10%):',
                          '\$${cart.tax.toStringAsFixed(2)}'),
                      const Divider(),
                      _buildTotalRow('Total:',
                          '\$${cart.total.toStringAsFixed(2)}',
                          isBold: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              orderState.isLoading ? null : handlePlaceOrder,
                          child: orderState.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildTotalRow(String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 18 : 16)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 18 : 16)),
        ],
      ),
    );
  }
}