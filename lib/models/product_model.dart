// product_model.dart
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final int id;
  final int idCategory;
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final String status;

  ProductModel({
    required this.id,
    required this.idCategory,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      idCategory: json['idCategory'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      status: json['status'],
    );
  }
}