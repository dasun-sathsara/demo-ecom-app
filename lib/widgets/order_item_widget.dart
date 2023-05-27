import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart' as model;

class OrderItem extends ConsumerStatefulWidget {
  const OrderItem(this.orderItem, {super.key});
  final model.OrderItem orderItem;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderItemState();
}

class _OrderItemState extends ConsumerState<OrderItem> {
  bool _expanded = false;

  Widget buildOrderItemTile() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${widget.orderItem.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(
                    DateFormat.yMMMEd().add_jm().format(widget.orderItem.date),
                    style: const TextStyle(color: Colors.black54),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
            ],
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.only(top: 25),
              height: min(widget.orderItem.cartItems.length * 35 + 20.0, 150),
              child: ListView.builder(
                  itemCount: widget.orderItem.cartItems.length,
                  itemBuilder: (context, index) => Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(widget.orderItem.cartItems[index].product.title),
                            Text(
                                '${widget.orderItem.cartItems[index].quantity} x \$${widget.orderItem.cartItems[index].product.price.toStringAsFixed(2)}')
                          ]),
                          const Divider(
                            thickness: 0.1,
                          )
                        ],
                      )),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        children: [
          Card(elevation: 0.7, child: buildOrderItemTile()),
        ],
      ),
    );
  }
}
