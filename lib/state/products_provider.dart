import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

class ProductsNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    return [];
  }

  List<Product> get allProducts => state;

  List<Product> get favoriteProducts => state.where((product) {
        return product.isFavorite;
      }).toList();

  Future<void> refreshProducts() async {
    await fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products.json');

    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty || responseBody == null) {
        return;
      }

      final products = <Product>[];

      (responseBody as Map<String, dynamic>).forEach((key, value) {
        products.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: (value as Map<String, dynamic>).containsKey('isFavorite') ? value['isFavorite'] : false));
      });

      state = products;
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    }
  }

  Future<void> addProduct({
    required String title,
    required num price,
    required String description,
    required String imageUrl,
  }) async {
    final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({'title': title, 'price': price, 'description': description, 'imageUrl': imageUrl}),
      );
      state = [
        ...state,
        Product(
          id: json.decode(response.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
        )
      ];
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    }
  }

  Future<void> removeProduct(String id) async {
    try {
      final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products/$id.json');

      var response = await http.delete(url);
      if (response.statusCode > 400) {
        throw const HttpException('Bad Status Code');
      }
      state = state.where((product) => product.id != id).toList();
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    } on HttpException {
      rethrow;
    }
  }

  Product getProduct(String id) {
    return state.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct({required Product updatedProduct}) async {
    try {
      final url = Uri.https(
        'shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/${updatedProduct.id}.json',
      );

      var response = await http.patch(
        url,
        body: json.encode(
          {
            'title': updatedProduct.title,
            'price': updatedProduct.price,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
          },
        ),
      );

      if (response.statusCode > 400) {
        throw const HttpException('Bad Status Code');
      }

      state = state.map((product) {
        if (product.id == updatedProduct.id) {
          return updatedProduct;
        } else {
          return product;
        }
      }).toList();
    } on FormatException {
      rethrow;
    } on http.ClientException {
      rethrow;
    } on HttpException {
      rethrow;
    }
  }

  void toggleFavorite(String productID) async {
    var currentStatus = state.firstWhere((product) => product.id == productID).isFavorite;

    void updateState(bool value) {
      state = state.map(
        (product) {
          if (product.id == productID) {
            return product.copyWith(isFavorite: value);
          } else {
            return product;
          }
        },
      ).toList();
    }

    try {
      final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products/$productID.json');
      updateState(!currentStatus);

      var response = await http.patch(
        url,
        body: json.encode({'isFavorite': !currentStatus}),
      );

      if (response.statusCode > 400) {
        throw const HttpException('Bad Status Code');
      }
    } on FormatException {
      updateState(currentStatus);
      rethrow;
    } on http.ClientException {
      updateState(currentStatus);
      rethrow;
    } on HttpException {
      updateState(currentStatus);
      rethrow;
    }
  }
}
