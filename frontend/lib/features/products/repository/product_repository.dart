import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/features/products/models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;
  ProductRepository(this._apiClient);

  Future<List<Product>> getProducts() async {
    final response = await _apiClient.dio.get('/api/products');
    final List<dynamic> productListJson = response.data;
    return productListJson.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _apiClient.dio.get('/api/products/$id');
    return Product.fromJson(response.data);
  }
}