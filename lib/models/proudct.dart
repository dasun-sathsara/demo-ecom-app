import 'package:freezed_annotation/freezed_annotation.dart';

part 'proudct.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product(
      {required String id,
      required String title,
      required String description,
      required double price,
      required String imageUrl,
      @Default(false) bool isFavorite}) = _Product;
}
