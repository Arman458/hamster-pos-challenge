import 'package:go_router/go_router.dart';
import 'package:hamster_pos_frontend/features/auth/screens/login_screen.dart';
import 'package:hamster_pos_frontend/features/auth/screens/register_screen.dart';
import 'package:hamster_pos_frontend/features/products/screens/catalog_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: LoginScreen.route,
    routes: [
      GoRoute(
        path: LoginScreen.route,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.route,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: CatalogScreen.route,
        builder: (context, state) => const CatalogScreen(),
      ),
    ],
  );
}
