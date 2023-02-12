import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers.dart';
import 'snack_bar_widget.dart';

class AddToCard extends ConsumerStatefulWidget {
  const AddToCard(this.product, {super.key});

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddToCardState();
}

class _AddToCardState extends ConsumerState<AddToCard> {
  int _currentQuantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (_currentQuantity >= 1) {
                      _currentQuantity--;
                    }
                  });
                },
                icon: const Icon(Icons.remove)),
            Text(
              _currentQuantity.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    _currentQuantity++;
                  });
                },
                icon: const Icon(Icons.add)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_currentQuantity >= 1) {
                    ref
                        .read(cartProvider.notifier)
                        .addWithQuantity(widget.product.id, _currentQuantity, widget.product);

                    showSnackBar(_currentQuantity, widget.product.id, ref, context);
                    _currentQuantity = 0;
                  }
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(width: 0, color: Colors.transparent),
                  ),
                ),
              ),
              child: const Text(
                'Add to Card ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
