import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/features/auth/models/auth_dtos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiClient _apiClient;
  AuthRepository(this._apiClient);

  Future<void> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    final authResponse = AuthResponse.fromJson(response.data);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', authResponse.token);
  }

  Future<UserResponse> register(RegisterRequest request) async {
    final response = await _apiClient.dio.post(
      '/auth/register',
      data: request.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}