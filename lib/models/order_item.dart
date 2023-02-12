import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required List<CartItem> cartItems,
    required double totalPrice,
    required DateTime date,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, Object?> json) => _$OrderItemFromJson(json);
}
