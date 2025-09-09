import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/widgets/main_app_bar.dart';
import 'package:hamster_pos_frontend/features/order/providers/order_provider.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends ConsumerWidget {
  static const route = '/orders';
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myOrdersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: const MainAppBar(title: 'My Orders'),
      body: myOrdersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('You have not placed any orders yet.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text(DateFormat.yMMMd().format(order.orderDate)),
                  trailing: Text(
                    '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: order.items
                      .map((item) => ListTile(
                            title: Text(item.productName),
                            subtitle: Text('Qty: ${item.quantity}'),
                            trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                          ))
                      .toList(),
                ),
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}