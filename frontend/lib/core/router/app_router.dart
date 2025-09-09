import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/features/admin/screens/admin_home_screen.dart';

import 'package:hamster_pos_frontend/features/auth/screens/login_screen.dart';
import 'package:hamster_pos_frontend/features/auth/screens/register_screen.dart';
import 'package:hamster_pos_frontend/features/order/screens/my_orders_screen.dart';
import 'package:hamster_pos_frontend/features/products/screens/catalog_screen.dart';
import 'package:hamster_pos_frontend/features/products/screens/product_detail_screen.dart';
import 'package:hamster_pos_frontend/features/products/providers/product_providers.dart';
import 'package:hamster_pos_frontend/features/cart/screens/cart_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: LoginScreen.route,
    routes: [
      // Auth routes
      GoRoute(
        path: LoginScreen.route,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.route,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Catalog + nested Product Detail
      GoRoute(
        path: CatalogScreen.route,
        builder: (context, state) => const CatalogScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: ProductDetailScreen.routeName,
            builder: (context, state) {
              final productId = int.parse(state.pathParameters['id']!);
              return Consumer(
                builder: (context, ref, child) {
                  final productAsync =
                      ref.watch(productDetailProvider(productId));
                  return productAsync.when(
                    data: (product) => ProductDetailScreen(product: product),
                    loading: () => const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => Scaffold(
                      body: Center(child: Text('Error: $err')),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      // Cart
      GoRoute(
        path: CartScreen.route,
        builder: (context, state) => const CartScreen(),
      ),

      // Orders
      GoRoute(
        path: MyOrdersScreen.route,
        builder: (context, state) => const MyOrdersScreen(),
      ),

      GoRoute(
        path: AdminHomeScreen.route,
        builder: (context, state) => const AdminHomeScreen(),
      ),
    ],
  );
}