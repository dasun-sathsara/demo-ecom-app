import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '/screens/cart_screen.dart';
import '/screens/edit_product_screen.dart';
import '/screens/manage_products_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/products_screen.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'ShopApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: const ColorScheme.light().copyWith(primary: Colors.deepPurple, secondary: Colors.yellow),
          appBarTheme: const AppBarTheme().copyWith(
              titleTextStyle: GoogleFonts.robotoSlab(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500)),
        ),
        routes: {
          ProductsScreen.routeName: (context) => const ProductsScreen(),
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          ManageProductsScreen.routeName: (context) => const ManageProductsScreen(),
          EditProductScreen.routeName: (context) => const EditProductScreen()
        },
      ),
    );
  }
}
