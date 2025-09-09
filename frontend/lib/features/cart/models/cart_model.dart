import 'package:hamster_pos_frontend/features/products/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;

  Cart({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });
}