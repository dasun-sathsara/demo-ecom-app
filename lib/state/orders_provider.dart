import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

Iterable<int> getId() sync* {
  int id = 0;
  while (true) {
    yield id;
    id++;
  }
}

class OrdersNotifier extends Notifier<List<OrderItem>> {
  Iterator<int> idIterator = getId().iterator;

  @override
  List<OrderItem> build() {
    return [];
  }

  List<OrderItem> get allOrders => state;

  void addOrder(List<CartItem> cartItems, double totalPrice) {
    idIterator.moveNext();
    state = [
      ...state,
      OrderItem(id: idIterator.current.toString(), totalPrice: totalPrice, cartItems: cartItems, date: DateTime.now())
    ];
  }
}
