import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/features/products/models/product_model.dart';
import 'package:hamster_pos_frontend/features/order/models/order_model.dart';

class AdminRepository {
  final ApiClient _apiClient;
  AdminRepository(this._apiClient);

  Future<List<Product>> getLowStockProducts() async {
    final response = await _apiClient.dio.get('/api/admin/low-stock');
    final List<dynamic> productListJson = response.data;
    return productListJson.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<OrderResponse>> getAllOrders() async {
    final response = await _apiClient.dio.get('/api/admin/orders');
    final List<dynamic> orderListJson = response.data;
    return orderListJson.map((json) => OrderResponse.fromJson(json)).toList();
  }

  Future<void> addProduct(String name, double price, int stock) async {
    await _apiClient.dio.post('/api/products', data: {
      'name': name,
      'price': price,
      'stock': stock,
    });
  }
}