import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/proudct.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  List<CartItem> get cartItems => state;
  int get numOfItems => state.length;

  double get totalPrice {
    return state.fold(0.0, (previousValue, cartItem) => previousValue + (cartItem.product.price * cartItem.quantity));
  }

  void addItem(Product product) {
    if (state.any((cartItem) => cartItem.id == product.id)) {
      state = state.map((cartItem) {
        if (cartItem.id == product.id) {
          return cartItem.copyWith(quantity: cartItem.quantity + 1);
        } else {
          return cartItem;
        }
      }).toList();
    } else {
      state = [...state, CartItem(id: product.id, product: product, quantity: 1)];
    }
  }

  void addWithQuantity(String productId, int quantity, Product product) {
    if (state.any((cartItem) => cartItem.id == productId)) {
      state = state.map((cartItem) {
        if (cartItem.id == productId) {
          return cartItem.copyWith(quantity: cartItem.quantity + quantity);
        } else {
          return cartItem;
        }
      }).toList();
    } else {
      state = [...state, CartItem(id: productId, product: product, quantity: quantity)];
    }
  }

  void removeQuantity(String id, int removeQuantity) {
    if (state.firstWhere((cartItem) => cartItem.id == id).quantity > removeQuantity) {
      print(removeQuantity);
      state = state.map(
        (cartItem) {
          if (cartItem.id == id) {
            return cartItem.copyWith(quantity: (cartItem.quantity - removeQuantity));
          } else {
            return cartItem;
          }
        },
      ).toList();
    } else {
      removeItem(id);
    }
  }

  void removeOnePiece(String id) {
    if (state.firstWhere((cartItem) => cartItem.id == id).quantity > 1) {
      state = state.map(
        (cartItem) {
          if (cartItem.id == id) {
            return cartItem.copyWith(quantity: cartItem.quantity - 1);
          } else {
            return cartItem;
          }
        },
      ).toList();
    } else {
      removeItem(id);
    }
  }

  void clearCart() {
    state = [];
  }

  CartItem getItem(String id) {
    return state.firstWhere((cartItem) => cartItem.id == id);
  }

  bool itemExists(String id) {
    return state.any((cartItem) => cartItem.id == id);
  }

  void removeItem(String id) {
    state = state.where((cartItem) => cartItem.id != id).toList();
  }
}
