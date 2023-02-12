import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'product_grid_item_widget.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid(this.showFavorites, {super.key});

  final bool showFavorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productsProvider.select((value) => value.length));
    var products = showFavorites
        ? ref.read(productsProvider.notifier).favoriteProducts
        : ref.read(productsProvider.notifier).allProducts;

    return showFavorites && ref.read(productsProvider.notifier).favoriteProducts.isEmpty
        ? const Center(
            child: Text(
              'No Favorite Products Yet',
              style: TextStyle(color: Color.fromARGB(255, 24, 23, 23), fontSize: 18),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 3 / 2),
            itemBuilder: (_, index) {
              return ProductGridItem(
                productID: products[index].id,
              );
            },
          );
  }
}
