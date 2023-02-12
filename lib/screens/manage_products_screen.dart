import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/manage_product_item_widget.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends ConsumerWidget {
  static const routeName = '/manage-proudcts';

  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productsProvider);
    var products = ref.read(productsProvider.notifier).allProducts;

    return ScaffoldMessenger(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0.5,
          label: const Text(
            'Add Product',
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
        ),
        appBar: AppBar(
          title: const Text('Manage Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const AppDrawer(),
        body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ManageProductItem(
                  product: products[index],
                )),
      ),
    );
  }
}
