import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'order_item.freezed.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required List<CartItem> cartItems,
    required double totalPrice,
    required DateTime date,
  }) = _OrderItem;
}
