import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(cartProvider);

    var cartItems = ref.read(cartProvider.notifier).cartItems;

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: Column(children: [
          Card(
              elevation: 0.25,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text('\$${ref.read(cartProvider.notifier).totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 17)),
                      side: const BorderSide(width: 0),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          if (ref.read(cartProvider).isNotEmpty) {
                            print(ref.read(ordersProvider));
                            ref
                                .read(ordersProvider.notifier)
                                .addOrder(cartItems, ref.read(cartProvider.notifier).totalPrice);
                            ref.read(cartProvider.notifier).clearCart();
                          }
                        },
                        child: const Text('ORDER NOW'))
                  ],
                ),
              )),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartItems.length, itemBuilder: (context, index) => CartItem(cartItem: cartItems[index])),
          )
        ]),
      ),
    );
  }
}
