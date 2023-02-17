import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/providers.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class OrdersNotifier extends Notifier<List<OrderItem>> {
  @override
  List<OrderItem> build() {
    return [];
  }

  List<OrderItem> get allOrders => state;

  Future<void> fetchAndSetOrders() async {

    try {
      final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'orders.json');
      var orders = <OrderItem>[];
      var response = await http.get(url);
      var responseBody = json.decode(response.body) as Map<String, dynamic>;

      responseBody.forEach((key, value) {
        orders.add(
          OrderItem(
            id: key,
            cartItems: (value['cartItems'] as List).map((cartItem) => CartItem.fromJson(cartItem)).toList(),
            totalPrice: value['totalPrice'],
            date: DateTime.parse(value['date']),
          ),
        );
      });

      state = orders;
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    } on HttpException {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, num totalPrice) async {
    try {
      final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'orders.json');

      var response = await http.post(url,
          body: json.encode(
            {
              'totalPrice': totalPrice,
              'date': DateTime.now().toIso8601String(),
              'cartItems': cartItems.map((cartItem) {
                return cartItem.toJson();
              }).toList()
            },
          ));
      state = [
        ...state,
        OrderItem(
            id: json.decode(response.body)['name'], totalPrice: totalPrice, cartItems: cartItems, date: DateTime.now())
      ];
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    } on HttpException {
      rethrow;
    }
  }
}
