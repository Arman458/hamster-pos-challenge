import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/features/admin/providers/admin_provider.dart';

class LowStockTab extends ConsumerWidget {
  const LowStockTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowStockAsync = ref.watch(lowStockProvider);

    return lowStockAsync.when(
      data: (products) => products.isEmpty
          ? const Center(child: Text('No low-stock products.'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('ID: ${p.id}'),
                  trailing: Text(
                    'Stock: ${p.stock}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                );
              }),
      error: (err, _) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}