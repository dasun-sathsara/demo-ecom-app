import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/badge_icon_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/products_grid_widget.dart';
import 'auth_screen.dart';
import 'cart_screen.dart';

enum Filters {
  favorites,
  all,
}

class ProductsScreen extends ConsumerStatefulWidget {
  static const routeName = '/products';

  const ProductsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  bool _showFavorites = false;
  var _isInit = false;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      ref.read(productsProvider.notifier).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

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
                initialValue: _showFavorites ? Filters.favorites : Filters.all,
                onSelected: (value) {
                  setState(() {
                    if (value == Filters.favorites) {
                      _showFavorites = true;
                    } else {
                      _showFavorites = false;
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(productsProvider.notifier).refreshProducts(),
                child: ProductGrid(_showFavorites)),
      ),
    );
  }
}
