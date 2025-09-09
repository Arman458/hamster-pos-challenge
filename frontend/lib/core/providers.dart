import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/api/api_client.dart';
import 'package:hamster_pos_frontend/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

// Provides a singleton instance of our ApiClient to the whole app
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Provides the GoRouter instance to the app
final goRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});