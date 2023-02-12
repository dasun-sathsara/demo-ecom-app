import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

void showSnackBar(int quantity, String id, WidgetRef ref, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      content: Text('$quantity ${quantity == 1 ? 'item' : 'items'} added to the card'),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          ref.read(cartProvider.notifier).removeQuantity(id, quantity);
        },
      ),
    ));
}
