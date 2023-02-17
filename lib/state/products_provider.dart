import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../providers.dart';

class ProductsNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    return [];
  }

  List<Product> get allProducts => state;
  List<Product> get ownProducts {
    var userId = ref.read(authProvider.notifier).userId;
    return state.where((product) => product.ownerId == userId).toList();
  }

  List<Product> get favoriteProducts => state.where((product) {
        return product.isFavorite;
      }).toList();

  Future<void> refreshProducts() async {
    await fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() async {
    final token = ref.read(authProvider.notifier).token;
    final userId = ref.read(authProvider.notifier).userId;

    final url =
        Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products.json', {'auth': token});
    final favoritesUrl = Uri.https(
        'shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'favorites/$userId.json', {'auth': token});

    try {
      final productsResponse = await http.get(url);
      final favoritesResponse = await http.get(favoritesUrl);
      final favoritesResponseBody = json.decode(favoritesResponse.body);
      final proudctsResponseBody = json.decode(productsResponse.body);
      print(favoritesResponseBody);

      if (proudctsResponseBody.isEmpty || proudctsResponseBody == null) {
        return;
      }

      final products = <Product>[];

      (proudctsResponseBody as Map<String, dynamic>).forEach((key, value) {
        products.add(Product(
            id: key,
            title: value['title'],
            ownerId: value['ownerId'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favoritesResponseBody == null
                ? false
                : (favoritesResponseBody as Map<String, dynamic>).containsKey(key)
                    ? (favoritesResponseBody)[key]!
                    : false));
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
    var token = ref.read(authProvider.notifier).token;
    var userId = ref.read(authProvider.notifier).userId;

    final url =
        Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products.json', {'auth': token});

    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'title': title, 'price': price, 'description': description, 'imageUrl': imageUrl, 'ownerId': userId}),
      );
      state = [
        ...state,
        Product(
          id: json.decode(response.body)['name'],
          title: title,
          ownerId: userId,
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
      final token = ref.read(authProvider.notifier).token;
      final url = Uri.https(
          'shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'products/$id.json', {'auth': token});

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
    final token = ref.read(authProvider.notifier).token;
    try {
      final url = Uri.https('shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app',
          'products/${updatedProduct.id}.json', {'auth': token});

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
      print(json.decode(response.body));

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

    var token = ref.read(authProvider.notifier).token;
    var userId = ref.read(authProvider.notifier).userId;

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
      final url = Uri.https(
          'shoapp-dx-default-rtdb.asia-southeast1.firebasedatabase.app', 'favorites/$userId.json', {'auth': token});
      updateState(!currentStatus);

      var response = await http.patch(
        url,
        body: json.encode({productID: !currentStatus}),
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
