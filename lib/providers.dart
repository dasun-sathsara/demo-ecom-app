import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/cart_item.dart';
import 'models/order_item.dart';
import 'models/product.dart';
import 'state/cart_provider.dart';
import 'state/orders_provider.dart';
import 'state/products_provider.dart';

final productsProvider = NotifierProvider<ProductsNotifier, List<Product>>(ProductsNotifier.new);
final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
final ordersProvider = NotifierProvider<OrdersNotifier, List<OrderItem>>(OrdersNotifier.new);
