import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/add_to_card_widget.dart';

class ProductDetailScreen extends ConsumerWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  Widget descriptionItem(String name, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '$name: ',
          style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          width: 2,
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String productID = ModalRoute.of(context)?.settings.arguments as String;
    var product = ref.read(productsProvider.notifier).getProduct(productID);

    return ScaffoldMessenger(
      child: Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            actions: [
              Consumer(builder: (context, ref, child) {
                ref.watch(productsProvider);
                var productN = ref.read(productsProvider.notifier);

                return IconButton(
                  iconSize: 30,
                  onPressed: () {
                    productN.toggleFavorite(productID);
                  },
                  color: Theme.of(context).colorScheme.primary,
                  icon: productN.getProduct(productID).isFavorite
                      ? const Icon(Icons.favorite_rounded)
                      : const Icon(Icons.favorite_border),
                );
              }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 300, width: double.infinity, child: Image.network(product.imageUrl, fit: BoxFit.cover)),
              AddToCard(product),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  children: [
                    descriptionItem('Product Name', product.title),
                    descriptionItem('Price', '\$${product.price}'),
                    descriptionItem('Description', product.description)
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}
