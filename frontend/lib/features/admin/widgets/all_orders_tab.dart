import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/features/admin/providers/admin_provider.dart';
import 'package:intl/intl.dart';

class AllOrdersTab extends ConsumerWidget {
  const AllOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrdersAsync = ref.watch(allOrdersProvider);

    return allOrdersAsync.when(
      data: (orders) => orders.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final o = orders[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text('Order #${o.id} by ${o.userEmail}'),
                    subtitle: Text(DateFormat.yMMMd().format(o.orderDate)),
                    trailing: Text(
                      '\$${o.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: o.items
                        .map((item) => ListTile(
                              title: Text(item.productName),
                              subtitle: Text('Qty: ${item.quantity}'),
                              trailing: Text(
                                  '\$${item.price.toStringAsFixed(2)}'),
                            ))
                        .toList(),
                  ),
                );
              }),
      error: (err, _) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}