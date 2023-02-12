import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product(
      {required String id,
      required String title,
      required String description,
      required num price,
      required String imageUrl,
      @Default(false) bool isFavorite}) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}
