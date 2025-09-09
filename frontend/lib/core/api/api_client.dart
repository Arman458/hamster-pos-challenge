import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:8081/api'; // IMPORTANT: Use 10.0.2.2 for Android Emulator

  ApiClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('jwt_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print('Auth error: Token might be expired. Clearing token.');
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('jwt_token');
            // In a real app, you'd navigate to the login screen here.
            // The router can be configured to handle this automatically.
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}