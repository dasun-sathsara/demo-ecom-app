import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart' as model;
import '../providers.dart';

class CartItem extends ConsumerWidget {
  final model.CartItem cartItem;
  const CartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dismissible(
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you want to delete this item from the cart?'),
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
                );
              });
        },
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            ref.read(cartProvider.notifier).removeItem(cartItem.id);
          }
        },
        key: ValueKey(cartItem.id),
        background: Card(
          color: Colors.red,
          child: Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              )),
        ),
        child: Card(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 90),
            child: ListTile(
              leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                      padding: const EdgeInsets.all(7), child: FittedBox(child: Text('\$${cartItem.product.price}')))),
              title: Text(cartItem.product.title),
              subtitle: Text(cartItem.product.description),
              trailing: Text('${cartItem.quantity} x'),
            ),
          ),
        ),
      ),
    );
  }
}
