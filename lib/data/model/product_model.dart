import 'package:clean/core/model.dart';
import 'package:clean/domain/enitites/product.dart';

class ProductModel implements Model<Product> {
  final String id;
  final String name;

  ProductModel({required this.id, required this.name});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(id: json['id'], name: json['name']);
  }

  @override
  Product toEntity() {
    return Product(
      id: id,
      nome: name,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
