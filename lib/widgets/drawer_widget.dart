import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopapp/providers.dart';

import '../screens/auth_screen.dart';
import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      if (!next.isLoggedIn) {
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => true);
      }
    });

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello User!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(thickness: 0.1, height: 0),
          ListTile(
            leading: const Icon(
              Icons.shop,
              size: 26,
            ),
            title: const Text('Shop', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
            },
          ),
          const Divider(thickness: 0.1, height: 5),
          ListTile(
            leading: const Icon(
              Icons.payment,
              size: 26,
            ),
            title: const Text('Orders', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(thickness: 0.1, height: 5),
          ListTile(
            leading: const Icon(
              Icons.edit,
              size: 26,
            ),
            title: const Text('Manage Products', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ManageProductsScreen.routeName);
            },
          ),
          const Divider(thickness: 0.1, height: 5),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              size: 26,
            ),
            title: const Text('Log Out', style: TextStyle(fontSize: 16)),
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
          const Divider(thickness: 0.1, height: 5),
        ],
      ),
    );
  }
}
