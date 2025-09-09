import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hamster_pos_frontend/features/admin/screens/admin_home_screen.dart';
import 'package:hamster_pos_frontend/features/auth/providers/auth_provider.dart';
import 'package:hamster_pos_frontend/features/auth/screens/login_screen.dart';
import 'package:hamster_pos_frontend/features/cart/screens/cart_screen.dart';
import 'package:hamster_pos_frontend/features/order/screens/my_orders_screen.dart';
import 'package:hamster_pos_frontend/features/products/screens/catalog_screen.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  const MainAppBar({
    super.key,
    required this.title,
    this.bottom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminAsyncValue = ref.watch(isAdminProvider);

    return AppBar(
      title: Text(title),
      bottom: bottom,
      leading: ModalRoute.of(context)?.canPop ?? false
          ? null
          : IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () => context.go(CatalogScreen.route),
            ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => context.go(CartScreen.route),
        ),
        IconButton(
          icon: const Icon(Icons.receipt_long_outlined),
          onPressed: () => context.go(MyOrdersScreen.route),
        ),
        isAdminAsyncValue.when(
          data: (isAdmin) => isAdmin
              ? IconButton(
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  onPressed: () => context.go(AdminHomeScreen.route),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox(width: 48),
          error: (_, __) => const SizedBox.shrink(),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(authRepositoryProvider).logout();
            if (context.mounted) {
              context.go(LoginScreen.route);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}