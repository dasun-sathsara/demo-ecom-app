import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/badge_icon_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/products_grid_widget.dart';
import 'cart_screen.dart';

enum Filters {
  favorites,
  all,
}

class ProductsScreen extends StatefulWidget {
  static const routeName = '/';

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                ref.watch(cartProvider);

                return BadgeIcon(value: ref.read(cartProvider.notifier).numOfItems, child: child!);
              },
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 26,
                ),
              ),
            ),
            PopupMenuButton(
                enableFeedback: true,
                initialValue: showFavorites ? Filters.favorites : Filters.all,
                onSelected: (value) {
                  setState(() {
                    if (value == Filters.favorites) {
                      showFavorites = true;
                    } else {
                      showFavorites = false;
                    }
                  });
                },
                elevation: 1,
                tooltip: 'Filters',
                icon: const Icon(Icons.more_vert),
                itemBuilder: (_) => const [
                      PopupMenuItem(value: Filters.favorites, child: Text('Show Favorites')),
                      PopupMenuItem(value: Filters.all, child: Text('Show All Products')),
                    ]),
          ],
        ),
        body: ProductGrid(showFavorites),
      ),
    );
  }
}