import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/features/models/products/models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;
  ProductRepository(this._apiClient);

  Future<List<Product>> getProducts() async {
    final response = await _apiClient.dio.get('/products');
    final List<dynamic> productListJson = response.data;
    return productListJson.map((json) => Product.fromJson(json)).toList();
  }
}