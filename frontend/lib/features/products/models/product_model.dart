import 'dart:convert';

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
    );
  }

  static List<Product> listFromJson(String jsonString) {
    final List<dynamic> parsed = jsonDecode(jsonString);
    return parsed.map((json) => Product.fromJson(json)).toList();
  }
}