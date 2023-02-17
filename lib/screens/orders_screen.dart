import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/order_item_widget.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  var _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      ref.read(ordersProvider.notifier).fetchAndSetOrders();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ordersProvider);

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () {
            return ref.read(ordersProvider.notifier).fetchAndSetOrders();
          },
          child: ListView(
              children: ref.read(ordersProvider.notifier).allOrders.map((orderItem) => OrderItem(orderItem)).toList()),
        ),
      ),
    );
  }
}
