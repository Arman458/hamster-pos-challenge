// In: lib/features/admin/screens/admin_home_screen.dart

import 'package:flutter/material.dart';
import 'package:hamster_pos_frontend/core/widgets/main_app_bar.dart';
import 'package:hamster_pos_frontend/features/admin/widgets/add_product_tab.dart';
import 'package:hamster_pos_frontend/features/admin/widgets/all_orders_tab.dart';
import 'package:hamster_pos_frontend/features/admin/widgets/low_stock_tab.dart';

class AdminHomeScreen extends StatelessWidget {
  static const route = '/admin';
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MainAppBar( // Now this is valid
          title: 'Admin Panel',
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_box), text: 'Add Product'),
              Tab(icon: Icon(Icons.list_alt), text: 'All Orders'),
              Tab(icon: Icon(Icons.warning), text: 'Low Stock'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddProductTab(),
            AllOrdersTab(),
            LowStockTab(),
          ],
        ),
      ),
    );
  }
}