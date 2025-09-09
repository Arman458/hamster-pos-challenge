import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/providers.dart';
import 'package:hamster_pos_frontend/features/products/models/product_model.dart';
import 'package:hamster_pos_frontend/features/products/repository/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProducts();
});