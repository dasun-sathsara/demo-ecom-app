import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers.dart';
import '../screens/product_detail_screen.dart';
import 'snack_bar_widget.dart';

class ProductGridItem extends ConsumerWidget {
  const ProductGridItem({super.key, required this.productID});

  final String productID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productsProvider.select((value) => value.firstWhere((element) => element.id == productID).isFavorite));
    var product = ref.read(productsProvider.notifier).getProduct(productID);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
              footer: Container(
                padding: const EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GridTileBar(
                    backgroundColor: Colors.black.withOpacity(0.7),
                    title: Text(
                      product.title,
                      style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    leading: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        ref.read(productsProvider.notifier).toggleFavorite(productID);
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      icon: product.isFavorite ? const Icon(Icons.favorite_rounded) : const Icon(Icons.favorite_border),
                    ),
                    trailing: IconButton(
                        iconSize: 30,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          ref.read(cartProvider.notifier).addItem(product);
                          showSnackBar(1, productID, ref, context);
                        },
                        icon: const Icon(Icons.shopping_cart)),
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Image.network(product.imageUrl, width: double.infinity, fit: BoxFit.cover),
                  Positioned(
                      left: -25,
                      top: 10,
                      child: Transform.rotate(
                        angle: -45 * pi / 180,
                        child: Container(
                            color: Colors.yellow,
                            height: 30,
                            width: 100,
                            child: Center(
                              child: Text(
                                '\$${product.price}',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            )),
                      )),
                  Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: productID);
                            },
                          )))
                ],
              )),
        ),
      ),
    );
  }
}
