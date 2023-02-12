import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dummy_data.dart';
import '../models/proudct.dart';

Iterable<String> getId() sync* {
  int id = 5;
  while (true) {
    yield 'p$id';
    id++;
  }
}

class ProductsNotifier extends Notifier<List<Product>> {
  Iterator<String> idIterator = getId().iterator;

  @override
  List<Product> build() {
    return dummyProducts;
  }

  List<Product> get allProducts => state;

  List<Product> get favoriteProducts => state.where((product) {
        return product.isFavorite;
      }).toList();

  void addProduct({
    required String title,
    required double price,
    required String description,
    required String imageUrl,
  }) {
    idIterator.moveNext();
    state = [
      ...state,
      Product(
        id: idIterator.current,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      )
    ];
  }

  void removeProduct(String id) {
    state = state.where((product) => product.id != id).toList();
  }

  Product getProduct(String id) {
    return state.firstWhere((product) => product.id == id);
  }

  void updateProduct({required Product updatedProduct}) {
    state = state.map((product) {
      if (product.id == updatedProduct.id) {
        return updatedProduct;
      } else {
        return product;
      }
    }).toList();
  }

  void toggleFavorite(String productID) {
    state = state.map(
      (product) {
        if (product.id == productID) {
          return product.copyWith(isFavorite: !product.isFavorite);
        } else {
          return product;
        }
      },
    ).toList();
  }
}
