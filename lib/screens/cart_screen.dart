import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends ConsumerStatefulWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  var _isOrderProcessing = false;

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () async {
                          if (ref.read(cartProvider).isNotEmpty) {
                            setState(() {
                              _isOrderProcessing = true;
                            });

                            await ref
                                .read(ordersProvider.notifier)
                                .addOrder(cartItems, ref.read(cartProvider.notifier).totalPrice);
                            ref.read(cartProvider.notifier).clearCart();
                            await Future.delayed(const Duration(seconds: 1));

                            setState(() {
                              _isOrderProcessing = false;
                            });
                          }
                        },
                        child: Container(
                            width: 90,
                            alignment: Alignment.center,
                            child: _isOrderProcessing
                                ? const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )))
                                : const Text('ORDER NOW')))
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
