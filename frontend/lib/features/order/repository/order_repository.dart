import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/features/order/models/order_model.dart';

class OrderRepository {
  final ApiClient _apiClient;
  OrderRepository(this._apiClient);

  Future<void> placeOrder(OrderRequest request) async {
    await _apiClient.dio.post('/api/orders', data: request.toJson());
  }

  Future<List<OrderResponse>> getMyOrders() async {
    final response = await _apiClient.dio.get('/api/orders/me');
    final List<dynamic> orderListJson = response.data;
    return orderListJson.map((json) => OrderResponse.fromJson(json)).toList();
  }
}