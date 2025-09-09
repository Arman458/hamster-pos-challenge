import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/features/admin/providers/admin_provider.dart';

class AddProductTab extends ConsumerWidget {
  const AddProductTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final addProductState = ref.watch(addProductControllerProvider);

    ref.listen(addProductControllerProvider, (prev, next) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    void handleAddProduct() async {
      if (formKey.currentState!.validate()) {
        final success = await ref.read(addProductControllerProvider.notifier).addProduct(
              nameController.text,
              priceController.text,
              stockController.text,
            );
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
          formKey.currentState?.reset();
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add Product', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => v!.isEmpty ? 'Enter a price' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Enter stock qty' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addProductState.isLoading ? null : handleAddProduct,
              child: addProductState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}