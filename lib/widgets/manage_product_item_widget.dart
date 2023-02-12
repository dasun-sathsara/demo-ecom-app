import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers.dart';
import '../screens/edit_product_screen.dart';

class ManageProductItem extends ConsumerWidget {
  final Product product;
  const ManageProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: CircleAvatar(radius: 32, backgroundImage: NetworkImage(product.imageUrl)),
          title: Text(product.title),
          subtitle: Text('\$ ${product.price.toStringAsFixed(2)}'),
          trailing: SizedBox(
            width: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text('Do you want to delete this product?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('No')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Yes'))
                              ],
                            )).then(
                      (value) async {
                        if (value == true) {
                          try {
                            await ref.read(productsProvider.notifier).removeProduct(product.id);
                          } catch (err) {
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('An error occurred!'),
                                content: const Text('Something went wrong while deleting the product.'),
                                actions: [
                                  TextButton(
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      })
                                ],
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: product.id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ]),
          ),
        ),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
